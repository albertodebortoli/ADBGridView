# ADBGridView

ADBGridView inherits from UITableView and is populated with ADBImageViews ([repository](http://github.com/albertodebortoli/ADBImageView)). Number of images for row (cells) can be customized. UITableView is inherited to use cell reuse facility. 

Try out the included demo project.

Simple usage:

- copy ADB* classes into your project
- import `ADBGridView.h` in your class
- create an IBOutlet for an ADBGridView and set the gridDelegate in InterfaceBuilder or create an instance of ADBGridView and set the delegate programmatically
- use delegation pattern implementing ADBGridViewDelegate protocol and related required delegate methods

``` objective-c
#pragma mark - ADBImageViewDelegate
- (NSString *)imagePathForADBGridView:(ADBGridView *)view atIndex:(NSUInteger)index { ... }
- (NSUInteger)numberOfImagesInGrid:(ADBGridView *)view { ... }
- (NSUInteger)numberOfImagesForRow:(ADBGridView *)view { ... }
```

- and optional delegate methods

``` objective-c
- (void)imageInADBGridView:(ADBGridView *)gridView singleTapImageView:(ADBImageView *)imageView { ... }
- (void)imageInADBGridView:(ADBGridView *)gridView longPressImageView:(ADBImageView *)imageView { ... }
```

![1](http://www.albertodebortoli.it/GitHub/ADBGridView/SS1.png)
![2](http://www.albertodebortoli.it/GitHub/ADBGridView/SS2.png)

# License

Licensed under the New BSD License.

Copyright (c) 2012, Alberto De Bortoli
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Alberto De Bortoli nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Alberto De Bortoli BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

## Resources

Info can be found on [my website](http://www.albertodebortoli.it), [and on Twitter](http://twitter.com/albertodebo).
