{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    maintainers
    mapAttrs'
    mkEnableOption
    mkOption
    nameValuePair
    optionalString
    types
    ;
  mkSystemdService =
    name: cfg:
    nameValuePair "gitwatch-${name}" (
      let
        getvar = flag: var: optionalString (cfg."${var}" != null) "${flag} ${cfg."${var}"}";
        getbool = flag: var: optionalString cfg."${var}" flag;
        branch = getvar "-b" "branch";
        remote = getvar "-r" "remote";
        debounce = getvar "-s" "debounceTime";
        dateFmt = getvar "-d" "dateFormat";
        gitdir = getvar "-g" "gitDir";
        msg = getvar "-m" "commitMessage";
        events = getvar "-e" "events";
        logColor = optionalString (cfg.logLines != null) "-l ${toString cfg.logLines}";
        logNoColor = optionalString (cfg.logLinesNoColor != null) "-L ${toString cfg.logLinesNoColor}";
        rebase = getbool "-R" "rebase";
        noMerge = getbool "-M" "noMerge";
        exclude = getvar "-x" "excludePattern";
      in
      rec {
        inherit (cfg) enable;
        after = [ "network-online.target" ];
        wants = after;
        wantedBy = [ "multi-user.target" ];
        description = "gitwatch for ${name}";
        path = with pkgs; [
          gitwatch
          git
          openssh
        ];
        script = ''
          if [ -n "${cfg.remote}" ] && ! [ -d "${cfg.path}" ]; then
            git clone ${branch} "${cfg.remote}" "${cfg.path}"
          fi
          gitwatch \
            ${remote} ${branch} \
            ${debounce} ${dateFmt} ${gitdir} ${msg} \
            ${logColor} ${logNoColor} ${events} \
            ${rebase} ${noMerge} ${exclude} \
            ${cfg.path}
        '';
        serviceConfig.User = cfg.user;
      }
    );
in
{
  options.services.gitwatch = mkOption {
    description = ''
      A set of git repositories to watch for. See
      [gitwatch](https://github.com/gitwatch/gitwatch) for more.
    '';
    default = { };
    example = {
      my-repo = {
        enable = true;
        user = "user";
        path = "/home/user/watched-project";
        remote = "git@github.com:me/my-project.git";
        debounceTime = 2;
        dateFormat = "+%Y-%m-%d %H:%M:%S";
        rebase = true;
        commitMessage = "Auto commit at %d";
        logLines = 10;
        excludePattern = "*.swp";
      };
    };
    type =
      with types;
      attrsOf (submodule {
        options = {
          enable = mkEnableOption "watching for repo";
          path = mkOption {
            description = "The path to repo in local machine";
            type = str;
          };
          user = mkOption {
            description = "The name of services's user";
            type = str;
            default = "root";
          };
          remote = mkOption {
            description = "Optional url of remote repository";
            type = nullOr str;
            default = null;
          };
          branch = mkOption {
            description = "Optional branch in remote repository";
            type = nullOr str;
            default = null;
          };
          debounceTime = mkOption {
            description = "Time to wait in seconds after a change before committing";
            type = nullOr int;
            default = 2;
          };
          dateFormat = mkOption {
            description = "The commit timestamp format string passed to `date`";
            type = nullOr str;
            default = "+%Y-%m-%d %H:%M:%S";
          };
          rebase = mkOption {
            description = "Pull and rebase before pushing";
            type = bool;
            default = false;
          };
          gitDir = mkOption {
            description = "Custom path to .git directory (used as --git-dir)";
            type = nullOr str;
            default = null;
          };
          commitMessage = mkOption {
            description = "Commit message format with %d for timestamp";
            type = nullOr str;
            default = null;
          };
          logLines = mkOption {
            description = "Maximum number of lines to log (color) in message";
            type = nullOr int;
            default = null;
          };
          logLinesNoColor = mkOption {
            description = "Maximum number of lines to log (no color) in message";
            type = nullOr int;
            default = null;
          };
          events = mkOption {
            description = "Custom inotify events string (e.g. modify,delete)";
            type = nullOr str;
            default = null;
          };
          noMerge = mkOption {
            description = "Prevent commits if merge is in progress";
            type = bool;
            default = false;
          };
          excludePattern = mkOption {
            description = "Exclude pattern for inotifywait.";
            type = nullOr str;
            default = null;
          };
        };
      });
  };
  config.systemd.services = mapAttrs' mkSystemdService config.services.gitwatch;
  meta.maintainers = with maintainers; [ shved ];
}
