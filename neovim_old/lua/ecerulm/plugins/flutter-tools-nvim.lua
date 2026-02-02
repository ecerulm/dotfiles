-- Dart / Flutter
-- https://github.com/nvim-flutter/flutter-tools.nvim
-- LSP for Flutter
-- FlutterRun - Run the current project. Respects config.debugger.enabled setting.
-- FlutterDebug - Force run current project in debug mode.
-- FlutterDevices - Brings up a list of connected devices to select from.
-- FlutterEmulators - Similar to devices but shows a list of emulators to choose from.
-- FlutterReload - Reload the running project.
-- FlutterRestart - Restart the current project.
-- FlutterQuit - Ends a running session.
-- FlutterAttach - Attach to a running app.
-- FlutterDetach - Ends a running session locally but keeps the process running on the device.
-- FlutterOutlineToggle - Toggle the outline window showing the widget tree for the given file.
-- FlutterOutlineOpen - Opens an outline window showing the widget tree for the given file.
-- FlutterDevTools - Starts a Dart Dev Tools server.
-- FlutterDevToolsActivate - Activates a Dart Dev Tools server.
-- FlutterCopyProfilerUrl - Copies the profiler url to your system clipboard (+ register). Note that commands FlutterRun and FlutterDevTools must be executed first.
-- FlutterLspRestart - This command restarts the dart language server, and is intended for situations where it begins to work incorrectly.
-- FlutterSuper - Go to super class, method using custom LSP method dart/textDocument/super.
-- FlutterReanalyze - Forces LSP server reanalyze using custom LSP method dart/reanalyze.
-- FlutterRename - Renames and updates imports if lsp.settings.renameFilesWithClasses == "always"
-- FlutterLogClear - Clears the log buffer.
-- FlutterLogToggle - Toggles the log buffer.


return {
	"nvim-flutter/flutter-tools.nvim",
	enabled = true,
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = true,
}
