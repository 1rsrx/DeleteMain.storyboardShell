#!/bin/bash

# Main.storyboardを削除
current_dir=$(basename "$(pwd)")
cd $current_dir/Base.lproj
rm Main.storyboard

# Info.plistの修正
cd ../
sed -i '' '/<key>UISceneStoryboardFile<\/key>/d' Info.plist
sed -i '' '/<string>Main<\/string>/d' Info.plist

# プロジェクトファイルの修正
cd ../
cd $current_dir.xcodeproj

projfile="project.pbxproj"
start_pattern="\/\* Main\.storyboard \*\/ = {"
start_line=$(grep -n "$start_pattern" "$projfile" | cut -d ":" -f1)
sed -i '' "${start_line},/};/d" $projfile

sed -i '' "/Main.storyboard/d" $projfile

sed -i '' '/INFOPLIST_KEY_UIMainStoryboardFile = Main;/d' $projfile

# SceneDelegateで初期画面を設定する
cd ../
cd $current_dir
target="guard let scene = (scene as? UIWindowScene) else { return }\n\t\tlet window = UIWindow(windowScene: scene)\n\t\twindow.rootViewController = ViewController()\n\t\twindow.makeKeyAndVisible()\n\t\tself.window = window"
sed -i "" "s/guard let _ = (scene as? UIWindowScene) else { return }/${target}/" "SceneDelegate.swift"
