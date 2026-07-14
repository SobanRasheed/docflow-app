# DocFlow project scaffold
# Run from inside the Flutter project root (after `flutter create docflow` and `cd docflow`)

$dirs = @(
    "lib\core\api",
    "lib\core\config",
    "lib\core\constants",
    "lib\core\theme",
    "lib\core\utils",
    "lib\models",
    "lib\controllers",
    "lib\services",
    "lib\views\screens\home",
    "lib\views\screens\upload",
    "lib\views\screens\progress",
    "lib\views\screens\done",
    "lib\views\screens\files",
    "lib\views\screens\settings",
    "lib\views\widgets\common",
    "lib\routes"
)

$files = @(
    "lib\main.dart",

    "lib\core\api\dio_client.dart",

    "lib\core\config\api_config.dart",

    "lib\core\constants\app_constants.dart",
    "lib\core\constants\file_constants.dart",

    "lib\core\theme\colors.dart",
    "lib\core\theme\theme.dart",

    "lib\core\utils\exceptions.dart",
    "lib\core\utils\validators.dart",
    "lib\core\utils\formatters.dart",

    "lib\models\tool_type.dart",
    "lib\models\conversion_task.dart",
    "lib\models\conversion_history_item.dart",

    "lib\controllers\home_controller.dart",
    "lib\controllers\upload_controller.dart",
    "lib\controllers\progress_controller.dart",
    "lib\controllers\done_controller.dart",
    "lib\controllers\files_controller.dart",
    "lib\controllers\settings_controller.dart",

    "lib\services\ilovepdf_service.dart",
    "lib\services\storage_service.dart",
    "lib\services\history_service.dart",
    "lib\services\permission_service.dart",

    "lib\views\screens\home\home_screen.dart",
    "lib\views\screens\upload\upload_screen.dart",
    "lib\views\screens\progress\progress_screen.dart",
    "lib\views\screens\done\done_screen.dart",
    "lib\views\screens\files\files_screen.dart",
    "lib\views\screens\settings\settings_screen.dart",

    "lib\views\widgets\common\app_button.dart",
    "lib\views\widgets\common\app_card.dart",
    "lib\views\widgets\common\glass_nav_bar.dart",
    "lib\views\widgets\common\tool_tile.dart",
    "lib\views\widgets\common\progress_indicator_widget.dart",
    "lib\views\widgets\common\empty_state.dart",

    "lib\routes\app_router.dart",
    "lib\routes\route_names.dart"
)

Write-Host "Creating directories..." -ForegroundColor Cyan
foreach ($dir in $dirs) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    Write-Host "  $dir"
}

Write-Host "`nCreating files..." -ForegroundColor Cyan
foreach ($file in $files) {
    New-Item -ItemType File -Path $file -Force | Out-Null
    Write-Host "  $file"
}

Write-Host "`nDocFlow scaffold complete." -ForegroundColor Green
