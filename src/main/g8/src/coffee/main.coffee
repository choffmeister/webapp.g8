requirejs.config
  baseUrl: "/js"
  paths:
    # external libraries
    jquery: "../bower_components/jquery/dist/jquery"
    underscore: "../bower_components/underscore/underscore"
    knockout: "../bower_components/knockout-dist/knockout"
    bootstrap: "../bower_components/bootstrap/dist/js/bootstrap"

  shim:
    underscore:
      exports: "_"
    bootstrap:
      deps: ["jquery"]

requirejs [
  "jquery"
  "underscore"
  "knockout"
  "bootstrap"
], (\$, _, ko, bs) ->
  # bootstrap application
  \$(document).ready () ->
    console.log("Application $name$ started")
