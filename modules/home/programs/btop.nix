{ lib, config, ...}:

{
    options.my.home.programs.btop.enable = lib.mkEnableOption "Enable my btop configuration";

    config = lib.mkIf config.my.home.programs.btop.enable {
        programs.btop = {
            enable = true;
            package = pkgs.btop.override {
                rocmSupport = true;
                cudaSupport = true;
            };
            settings = {
                vim_keys = true;
                rounded_corners = true;
                proc_tree = true;
                show_gpu_info = "on";
                show_uptime = true;
                show_coretemp = true;
                cpu_sensor = "auto";
                show_disks = false;
                only_physical = true;
                io_mode = true;
                io_graph_combined = false;
            };
        };
    };
}