{ pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    package = pkgs.yazi;
    settings = {
      mgr = {
        ratio = [
          1
          2
          4
        ];
        show_hidden = true;
      };
      preview = {
        max_height = 800;
        max_width = 1000;
      };
    };
    shellWrapperName = "y";
    theme = {
      indicator = {
        current = {
          fg = "#e0def4";
          bg = "#26233a";
        };
        preview = {
          underline = true;
        };
      };

      tabs = {
        active = {
          fg = "#e0def4";
          bg = "#191724";
        };
        inactive = {
          fg = "#e0def4";
          bg = "#2A273F";
        };
      };
      # tab_width = 1;

      mgr = {
        cwd = {
          fg = "#9ccfd8";
        };

        # Find
        find_keyword = {
          fg = "#f6c177";
          italic = true;
        };
        find_position = {
          fg = "#eb6f92";
          bg = "reset";
          italic = true;
        };

        # Marker
        marker_selected = {
          fg = "#9ccfd8";
          bg = "#9ccfd8";
        };
        marker_copied = {
          fg = "#f6c177";
          bg = "#f6c177";
        };
        marker_cut = {
          fg = "#B4637A";
          bg = "#B4637A";
        };

        # Border
        border_symbol = "│";
        border_style = {
          fg = "#524f67";
        };

        # Highlighting
        syntect_theme = "~/.config/yazi/rose-pine.tmTheme";
      };

      mode = {
        normal_main = {
          fg = "#191724";
          bg = "#ebbcba";
          bold = true;
        };
        select_main = {
          fg = "#e0def4";
          bg = "#9ccfd8";
          bold = true;
        };
        unset_main = {
          fg = "#e0def4";
          bg = "#b4637a";
          bold = true;
        };
      };

      status = {
        separator_left = "";
        separator_right = "";
        separator_style = {
          fg = "#2A273F";
          bg = "#2A273F";
        };

        # Progress
        progress_label = {
          fg = "#e0def4";
          bold = true;
        };
        progress_normal = {
          fg = "#191724";
          bg = "#2A273F";
        };
        progress_error = {
          fg = "#B4637A";
          bg = "#2A273F";
        };

        # Permissions
        perm_type = {
          fg = "#31748f";
        };
        perm_read = {
          fg = "#f6c177";
        };
        perm_write = {
          fg = "#B4637A";
        };
        perm_exec = {
          fg = "#9ccfd8";
        };
        perm_sep = {
          fg = "#524f67";
        };
      };

      input = {
        border = {
          fg = "#524f67";
        };
        title = { };
        value = { };
        selected = {
          reversed = true;
        };
      };

      pick = {
        border = {
          fg = "#524f67";
        };
        active = {
          fg = "#eb6f92";
        };
        inactive = { };
      };

      tasks = {
        border = {
          fg = "#524f67";
        };
        title = { };
        hovered = {
          underline = true;
        };
      };

      which = {
        mask = {
          bg = "#313244";
        };
        cand = {
          fg = "#9ccfd8";
        };
        rest = {
          fg = "#9399b2";
        };
        desc = {
          fg = "#eb6f92";
        };
        separator = "  ";
        separator_style = {
          fg = "#585b70";
        };
      };

      help = {
        on = {
          fg = "#eb6f92";
        };
        run = {
          fg = "#9ccfd8";
        };
        desc = {
          fg = "#9399b2";
        };
        hovered = {
          bg = "#585b70";
          bold = true;
        };
        footer = {
          fg = "#2A273F";
          bg = "#e0def4";
        };
      };

      filetype = {
        rules = [
          # Images
          {
            mime = "image/*";
            fg = "#9ccfd8";
          }

          # Videos
          {
            mime = "video/*";
            fg = "#f6c177";
          }
          {
            mime = "audio/*";
            fg = "#f6c177";
          }

          # Archives
          {
            mime = "application/zip";
            fg = "#eb6f92";
          }
          {
            mime = "application/gzip";
            fg = "#eb6f92";
          }
          {
            mime = "application/x-tar";
            fg = "#eb6f92";
          }
          {
            mime = "application/x-bzip";
            fg = "#eb6f92";
          }
          {
            mime = "application/x-bzip2";
            fg = "#eb6f92";
          }
          {
            mime = "application/x-7z-compressed";
            fg = "#eb6f92";
          }
          {
            mime = "application/x-rar";
            fg = "#eb6f92";
          }

          # Fallback
          {
            url = "*";
            fg = "#e0def4";
          }
          {
            url = "*/";
            fg = "#524f67";
          }
          {
            url = "*";
            is = "orphan";
            fg = "red";
          }
          {
            url = "*/";
            fg = "blue";
          }
        ];
      };
    };
  };
}
