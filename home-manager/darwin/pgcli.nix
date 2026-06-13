{
  config,
  pkgs,
  ...
}:
{
  programs.pgcli = {
    enable = true;
    settings = {
      main = {
        # Enables context sensitive auto-completion. If this is disabled, all
        # possible completions will be listed.
        smart_completion = true;
        # Display the completions in several columns. (More completions will be
        # visible.)
        wider_completion_menu = false;
        # Do not create new connections for refreshing completions; Equivalent to
        # always running with the --single-connection flag.
        always_use_single_connection = false;
        # Multi-line mode allows breaking up the sql statements into multiple lines. If
        # this is set to True, then the end of the statements must have a semi-colon.
        # If this is set to False then sql statements can't be split into multiple
        # lines. End of line (return) is considered as the end of the statement.
        multi_line = false;
        # If multi_line_mode is set to "psql", in multi-line mode, [Enter] will execute
        # the current input if the input ends in a semicolon.
        # If multi_line_mode is set to "safe", in multi-line mode, [Enter] will always
        # insert a newline, and [Esc] [Enter] or [Alt]-[Enter] must be used to execute
        # a command.
        multi_line_mode = "psql";
        # Destructive warning will alert you before executing a sql statement
        # that may cause harm to the database such as "drop table", "drop database",
        # "shutdown", "delete", or "update".
        # You can pass a list of destructive commands or leave it empty if you want to skip all warnings.
        # "unconditional_update" will warn you of update statements that don't have a where clause
        destructive_warning = "drop shutdown delete truncate alter update unconditional_update";

        # When `destructive_warning` is on and the user declines to proceed with a
        # destructive statement, the current transaction (if any) is left untouched,
        # by default. When setting `destructive_warning_restarts_connection` to
        # "True", the connection to the server is restarted. In that case, the
        # transaction (if any) is rolled back.
        destructive_warning_restarts_connection = false;
        # When this option is on (and if `destructive_warning` is not empty),
        # destructive statements are not executed when outside of a transaction.
        destructive_statements_require_transaction = false;
        # Enables expand mode, which is similar to `\x` in psql.
        expand = false;
        # Enables auto expand mode, which is similar to `\x auto` in psql.
        auto_expand = false;
        # Auto-retry queries on connection failures and other operational errors. If
        # False, will prompt to rerun the failed query instead of auto-retrying.
        auto_retry_closed_connection = true;
        # If set to True, table suggestions will include a table alias
        generate_aliases = false;
        # log_file location.
        # In Unix/Linux: ~/.config/pgcli/log
        log_file = "default";
        # keyword casing preference. Possible values: "lower", "upper", "auto"
        keyword_casing = "auto";
        # casing_file location.
        # In Unix/Linux: ~/.config/pgcli/casing
        casing_file = "default";
        # If generate_casing_file is set to True and there is no file in the above
        # location, one will be generated based on usage in SQL/PLPGSQL functions.
        generate_casing_file = false;
        # Casing of column headers based on the casing_file described above
        case_column_headers = true;
        # history_file location.
        # In Unix/Linux: ~/.config/pgcli/history
        history_file = "default";
        # Default log level. Possible values: "CRITICAL", "ERROR", "WARNING", "INFO"
        # and "DEBUG". "NONE" disables logging.
        log_level = "INFO";
        # Order of columns when expanding * to column list
        # Possible values: "table_order" and "alphabetic"
        asterisk_column_order = "table_order";
        # Whether to qualify with table alias/name when suggesting columns
        # Possible values: "always", "never" and "if_more_than_one_table"
        qualify_columns = "if_more_than_one_table";
        # When no schema is entered, only suggest objects in search_path
        search_path_filter = false;
        # Default pager. See https://www.pgcli.com/pager for more information on settings.
        # By default 'PAGER' environment variable is used. If the pager is less, and the 'LESS'
        # environment variable is not set, then LESS='-SRXF' will be automatically set.
        # pager = "less";
        # Timing of sql statements and table rendering.
        timing = true;
        # Show/hide the informational toolbar with function keymap at the footer.
        show_bottom_toolbar = true;
        # Table format. Possible values: psql, plain, simple, grid, fancy_grid, pipe,
        # ascii, double, github, orgtbl, rst, mediawiki, html, latex, latex_booktabs,
        # textile, moinmoin, jira, vertical, tsv, csv, sql-insert, sql-update,
        # sql-update-1, sql-update-2 (formatter with sql-* prefix can format query
        # output to executable insertion or updating sql).
        # Recommended: psql, fancy_grid and grid.
        table_format = "psql";
        # Syntax Style. Possible values: manni, igor, xcode, vim, autumn, vs, rrt,
        # native, perldoc, borland, tango, emacs, friendly, monokai, paraiso-dark,
        # colorful, murphy, bw, pastie, paraiso-light, trac, default, fruity
        syntax_style = "default";
        vi = true;
        # Error handling
        # When one of multiple SQL statements causes an error, choose to either
        # continue executing the remaining statements, or stopping
        # Possible values "STOP" or "RESUME"
        on_error = "STOP";
        # Set threshold for row limit. Use 0 to disable limiting.
        row_limit = 1000;
        # Truncate long text fields to this value for tabular display (does not apply to csv).
        # Leave unset to disable truncation. Example: "max_field_width = "
        # Be aware that formatting might get slow with values larger than 500 and tables with
        # lots of records.
        max_field_width = 500;
        # Skip intro on startup and goodbye on exit
        less_chatty = false;
        # Show all Postgres error fields (as listed in
        # https://www.postgresql.org/docs/current/protocol-error-fields.html).
        # Can be toggled with \v.
        verbose_errors = false;
        # Postgres prompt
        # \t - Current date and time
        # \u - Username
        # \h - Short hostname of the server (up to first '.')
        # \H - Hostname of the server
        # \d - Database name
        # \p - Database port
        # \i - Postgres PID
        # \# - "@" sign if logged in as superuser, '>' in other case
        # \n - Newline
        # \dsn_alias - name of dsn connection string alias if -D option is used (empty otherwise)
        # \x1b[...m - insert ANSI escape sequence
        # eg: prompt = '\x1b[35m\u@\x1b[32m\h:\x1b[36m\d>'
        prompt = "'\\u@\\h:\\d> '";
        # Number of lines to reserve for the suggestion menu
        min_num_menu_lines = 4;
        # Character used to left pad multi-line queries to match the prompt size.
        multiline_continuation_char = "";
        # The string used in place of a null value.
        null_string = "<null>";
        # manage pager on startup
        enable_pager = true;
        # Use keyring to automatically save and load password in a secure manner
        keyring = true;
        # Automatically set the session time zone to the local time zone
        # If unset, uses the server's time zone, which is the Postgres default
        use_local_timezone = true;

      };
      # Custom colors for the completion menu, toolbar, etc.
      colors = {
        "completion-menu.completion.current" = "'bg:#ffffff #000000'";
        "completion-menu.completion" = "'bg:#008888 #ffffff'";
        "completion-menu.meta.completion.current" = "'bg:#44aaaa #000000'";
        "completion-menu.meta.completion" = "'bg:#448888 #ffffff'";
        "completion-menu.multi-column-meta" = "'bg:#aaffff #000000'";
        "scrollbar.arrow" = "'bg:#003333'";
        "scrollbar" = "'bg:#00aaaa'";
        "selected" = "'#ffffff bg:#6666aa'";
        "search" = "'#ffffff bg:#4444aa'";
        "search.current" = "'#ffffff bg:#44aa44'";
        "bottom-toolbar" = "'bg:#222222 #aaaaaa'";
        "bottom-toolbar.off" = "'bg:#222222 #888888'";
        "bottom-toolbar.on" = "'bg:#222222 #ffffff'";
        "search-toolbar" = "'noinherit bold'";
        "search-toolbar.text" = "'nobold'";
        "system-toolbar" = "'noinherit bold'";
        "arg-toolbar" = "'noinherit bold'";
        "arg-toolbar.text" = "'nobold'";
        "bottom-toolbar.transaction.valid" = "'bg:#222222 #00ff5f bold'";
        "bottom-toolbar.transaction.failed" = "'bg:#222222 #ff005f bold'";
        # These three values can be used to further refine the syntax highlighting.;
        # They are commented out by default, since they have priority over the theme set;
        # with the `syntax_style` setting and overriding its behavior can be confusing.;
        "literal.string" = "'#ba2121'";
        "literal.number" = "'#666666'";
        "keyword" = "'bold #008000'";

        # style classes for colored table output
        "output.header" = "'#00ff5f bold'";
        "output.odd-row" = "''";
        "output.even-row" = "''";
        "output.null" = "'#808080'";
      };
      data_formats = {
        decimal = "";
        float = "";
      };
    };
  };
}
