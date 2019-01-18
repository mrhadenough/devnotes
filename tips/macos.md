### MacOSX install java
```
brew update
brew cask install java
```

### Password generator osx

```
brew install pwgen
pwgen -Bs 10 1
```

### Alternative to htop and system monitor

`brew install glances`

### Allow applications downloaded from anywhere in macOS Sierra

`sudo spctl --master-disable`

### OSX restart UI components

The Finder crashed:

`killall -KILL Finder`

The Dock crashed:

`killall -KILL Dock`

The Menubar crashed/refuses to be clickable:

`killall -KILL SystemUIServer`

### Install CUDA for OSX for blender

`The version ('70300') of the host compiler ('Apple clang') is not supported` install CUDA 6.5 Production Release

### Font smooth

Enabling Font Smoothing in Terminal

```defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO```

Revert to the default macOS Mojave settings

```defaults write -g CGFontRenderingFontSmoothingDisabled -bool YES```

Light font smoothing

```defaults -currentHost write -globalDomain AppleFontSmoothing -int 1```

Medium font smoothing

```defaults -currentHost write -globalDomain AppleFontSmoothing -int 2```

Strong font smoothing

```defaults -currentHost write -globalDomain AppleFontSmoothing -int 3```
