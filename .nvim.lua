-- .nvim.lua
-- If you have more than one setup configured you will be prompted when you run
-- your app to select which one you want to use
require('flutter-tools').setup_project({
  {
    name = 'Development',     -- an arbitrary name that you provide so you can recognise this config
    flavor = 'DevFlavor',     -- your flavour
    target = 'lib/main.dart', -- your target
    device = 'pixel6pro',     -- the device ID, which you can get by running `flutter devices`
    dart_define = {
      API_URL = 'https://dev.example.com/api',
      IS_DEV = true,
    },
    dart_define_from_file = 'config.json' -- the path to a JSON configuration file
  },
})
