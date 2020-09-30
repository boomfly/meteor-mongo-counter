Package.describe({
  name: 'konecty:mongo-counter',
  summary: "Atomic counters stored in MongoDB",
  version: "0.0.6",
  git: "https://github.com/Konecty/meteor-mongo-counter.git"
});

Package.onUse(function (api) {
  api.versionsFrom("METEOR@1.6");
  api.use('underscore', 'server');
  api.use('ecmascript', 'server');
  api.use(['coffeescript', 'mongo-livedata'], 'server');
  api.mainModule('counter.coffee', 'server');
});

Package.onTest(function(api) {
  api.use('coffeescript');
  api.use('tinytest');
  api.use('konecty:mongo-counter');
  api.addFiles('tests.counter.coffee', 'server');
});
