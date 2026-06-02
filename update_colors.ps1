$files = @(
    "C:\Alithim\bill_saving_app\lib\features\dumb\complete_request.dart",
    "C:\Alithim\bill_saving_app\lib\features\dumb\new\dateTime_picker.dart",
    "C:\Alithim\bill_saving_app\lib\features\dumb\new\offer_details.dart",
    "C:\Alithim\bill_saving_app\lib\features\dumb\new\profile_screen.dart",
    "C:\Alithim\bill_saving_app\lib\features\dumb\new\sign_contract_deataisl.dart",
    "C:\Alithim\bill_saving_app\lib\features\dumb\new\sign_contract_screen.dart",
    "C:\Alithim\bill_saving_app\lib\features\dumb\new\support_screen.dart",
    "C:\Alithim\bill_saving_app\lib\features\dumb\new_complete.dart",
    "C:\Alithim\bill_saving_app\lib\features\dumb\warmup_onboarding.dart",
    "C:\Alithim\bill_saving_app\lib\features\home\email\email_bill_receive_screen.dart",
    "C:\Alithim\bill_saving_app\lib\features\home\email\email_bill_screen.dart",
    "C:\Alithim\bill_saving_app\lib\features\home\sign_contract\sign_contract.dart",
    "C:\Alithim\bill_saving_app\lib\features\home\widgets\how_it_works.dart",
    "C:\Alithim\bill_saving_app\lib\features\home\widgets\upload_section.dart",
    "C:\Alithim\bill_saving_app\lib\features\home\widgets\utilities_section.dart",
    "C:\Alithim\bill_saving_app\lib\features\my_utility\utility_details_screen.dart",
    "C:\Alithim\bill_saving_app\lib\features\onboarding\warmup.dart",
    "C:\Alithim\bill_saving_app\lib\features\profile\invite_friends\invite_controller.dart",
    "C:\Alithim\bill_saving_app\lib\features\profile\invite_friends\invite_friends.dart",
    "C:\Alithim\bill_saving_app\lib\features\profile\personal_data_screen.dart",
    "C:\Alithim\bill_saving_app\lib\features\profile\settings\fq.dart",
    "C:\Alithim\bill_saving_app\lib\features\profile\settings\fq_bill.dart",
    "C:\Alithim\bill_saving_app\lib\features\profile\settings\fq_utilities.dart",
    "C:\Alithim\bill_saving_app\lib\features\profile\settings\my_requests_profile.dart",
    "C:\Alithim\bill_saving_app\lib\features\profile\settings\my_utilities_profile_screen.dart",
    "C:\Alithim\bill_saving_app\lib\features\profile\upgrade_to_bussiness.dart",
    "C:\Alithim\bill_saving_app\lib\features\profile\widgets\upgrade_to_business_sheet.dart",
    "C:\Alithim\bill_saving_app\lib\features\request\complete_request\complete_request_screen.dart"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = [System.IO.File]::ReadAllText($file)
        if ($content -match "9400D3") {
            $newContent = $content -replace "const\s+Color\(0x[fF]{2}9400D3\)", "AppColors.primaryColor"
            $newContent = $newContent -replace "Color\(0x[fF]{2}9400D3\)", "AppColors.primaryColor"
            $newContent = $newContent -replace "const\s+Color\(0xff9400D3\)", "AppColors.primaryColor"
            $newContent = $newContent -replace "Color\(0xff9400D3\)", "AppColors.primaryColor"
            
            if ($newContent -ne $content) {
                if ($newContent -notmatch "import 'package:vyzi/core/utils/app_colors.dart';") {
                    if ($newContent -match "import '") {
                         # Using regex to insert after the first import might be better to avoid issues with commented out imports
                         $newContent = $newContent -replace "(import ')", "import 'package:vyzi/core/utils/app_colors.dart';`r`n`$1"
                    } else {
                         $newContent = "import 'package:vyzi/core/utils/app_colors.dart';`r`n" + $newContent
                    }
                }
                [System.IO.File]::WriteAllText($file, $newContent)
                Write-Output "Updated $file"
            }
        }
    } else {
        Write-Output "File not found: $file"
    }
}
