# Aquarius

Aquarius is a general-purpose LÖVE library containing various classes and functions that I've found myself sharing between projects.

Aquarius (and this readme) are a work-in-progress.

## Features

- `Scene` and `SceneManager` classes, which allow you to partition your project into independent scenes, who manage their own resources and come with their own event handlers. The scene manager handles initialising, disposing of, switching between and passing events to scenes.

- A `Tweener` class, which can smoothly transition any property of any table between two values. The smoothing function can be customised; several functions are provided, such as linear and sinusoidal.

## Licence

Aquarius is licensed under the MIT Licence. This licence is presented in LICENCE.txt, and below:

```
MIT License

Copyright (c) 2022 Elizabeth G. Bland <liz@flompy.zone>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
