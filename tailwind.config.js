module.exports = {
  content: [
    "./app/assets/stylesheets/**/*.css",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.html.erb",
    "./config/initializers/customize_form_error_rendering.rb"
  ],

  daisyui: {
    base: true,
    darkTheme: "wireframe",
    logs: true,
    prefix: "",
    rtl: false,
    styled: true,
    themes: ["wireframe"],
    utils: true,
  },

  plugins: [require("daisyui")]
}
