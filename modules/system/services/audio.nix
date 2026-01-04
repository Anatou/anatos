{ lib, config, pkgs, ...}:

{
    options.my.system.services.pipewire.enable = lib.mkEnableOption "Enable my pipewire configuration";

    config = lib.mkIf config.my.system.services.pipewire.enable {
        services.pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
            jack.enable = true;
            extraConfig.pipewire."92-low-latency" = {
                "context.properties" = {
                "default.clock.rate" = 48000;
                "default.clock.quantum" = 256;
                "default.clock.min-quantum" = 256;
                "default.clock.max-quantum" = 256;
                };
            };
            extraConfig.pipewire-pulse."92-low-latency" = {
                context.modules = [
                {
                    name = "libpipewire-module-protocol-pulse";
                    args = {
                    pulse.min.req = "256/48000";
                    pulse.default.req = "256/48000";
                    pulse.max.req = "256/48000";
                    pulse.min.quantum = "256/48000";
                    pulse.max.quantum = "256/48000";
                    };
                }
                ];
            };

            configPackages = [
                (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/combine-stream.conf" ''
                    context.modules = [
                        {   name = libpipewire-module-combine-stream
                            args = {
                                combine.mode = sink
                                node.name = "my_combined_sink"
                                node.description = "My Combined Sink"
                                combine.props = {
                                    audio.position = [ FL FR ]
                                }
                                stream.rules = [
                                    {
                                        matches = [
                                            {
                                                media.class = "Audio/Sink"
                                            }
                                        ]
                                        actions = {
                                            create-stream = {
                                            }
                                        }
                                    }
                                ]
                            }
                        }
                    ]
                '')
            ];
        };

        environment.systemPackages = with pkgs; [
            pavucontrol
            qpwgraph
        ];
    };
}