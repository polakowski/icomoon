# Icomoon
This helper will make using Icomoon icons set easier.

## Usage
If you want to use Icomoon icons on your project, this is what will help you.

### Installation
Add this to your Gemfile:
```ruby
gem 'icomoon'
```
And then `bundle install`. You can always run `icomoon help` if you need help.

### Getting started
- run `icomoon init`

### Adding/removing icons (basically updating your icon set)
- open [IcoMoon App](https://icomoon.io/app/#/projects)
- click "Import Project" and select icomoon.json file from your project (it's located in the "Directory of fonts files" directory from the survey you took before)
- click "Load" on the imported project
- add/remove icons, change project preferences
- download set and unzip without changing folder name
- run `icomoon import` and specify location of unzipped icon set (`--dir` or `-d`)
- update icons file code (will display)

## Requirements
- ruby 2.2.2 or higher
- requires your application to use SASS/SCSS

## Note
It was tested on OS X only, not tested on Linux nor Windows.
