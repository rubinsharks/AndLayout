
## AndLayout
You can set IOS layout using Android style layout with xml.

Supported View
- RelativeLayout
- LinearLayout
- FrameLayout
- TextView
- Button
- ImageView

## Structure
#### android_values
It is same as values in android.
Now only supports colors.xml, dimens.xml, strings.xml

#### android_drawable - Not supported yet.
It is same as drawable in android.
You can set your drawable file in this folder.

#### android_layout
It is same as layout in android.
You can set your layout file in this folder like activity_main.xml

## Example
#### in UIViewController
```
    let parser = TKLayoutParser(frame: self.view.frame)
    var view = parser.getViewFromXML(fromXML: "main")
    var button = view!.findViewById(id: "button")
    if let clickButton = button as? UIButton {
        clickButton.addTarget(self, action: #selector(buttonClicked), for: UIControlEvents.touchUpInside)
    }
    if let uiview = view as? UIView {
        self.view = uiview
    }
```

## License
```
Copyright 2017 Taekyu Yeom

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
