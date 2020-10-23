let mix = require("laravel-mix");

/*
 |--------------------------------------------------------------------------
 | Mix Asset Management
 |--------------------------------------------------------------------------
 |
 | Mix provides a clean, fluent API for defining some Webpack build steps
 | for your Laravel application. By default, we are compiling the Sass
 | file for the application as well as bundling up all the JS files.
 |
 */

mix.js('resources/assets/js/app.js', 'public/js')
   .js('resources/assets/js/landing.js', 'public/js')
   .js('resources/assets/js/newsletter.js', 'public/js')
   .js('resources/assets/js/test.js', 'public/js')
   .js('resources/assets/js/photo-uploader.js', 'public/js')
   .js('resources/assets/js/validation/phone-verify.js', 'public/js')
   .js('resources/assets/js/validation/phone-verification.js', 'public/js')
   .js('resources/assets/js/validation/phone-verification-profile.js', 'public/js')
   .js('resources/assets/js/common-forms/basic-data.js', 'public/js')
   .js('resources/assets/js/common-forms/location-data.js', 'public/js')
   .js('resources/assets/js/common-forms/save-button.js', 'public/js')
   .js('resources/assets/js/auth/auth.js', 'public/js')
   .js('resources/assets/js/tenant-forms/first-step-three.js', 'public/js')
   .js('resources/assets/js/tenant-forms/second-step-employee.js', 'public/js')
   .js('resources/assets/js/tenant-forms/second-step-unemployed.js', 'public/js')
   .js('resources/assets/js/tenant-forms/second-step-own.js', 'public/js')
   .js('resources/assets/js/tenant-forms/second-step.js', 'public/js')
   .js('resources/assets/js/tenant-forms/third-step-two-2.js', 'public/js')
   .js('resources/assets/js/tenant-forms/third-step-two.js', 'public/js')
   .js('resources/assets/js/tenant-forms/third-step-one.js', 'public/js')
   .js('resources/assets/js/tenant-forms/third-step-three.js', 'public/js')
   .js('resources/assets/js/property-forms/first-step.js', 'public/js/property-forms')
   .js('resources/assets/js/property-forms/first-step-one.js', 'public/js/property-forms')
   .js('resources/assets/js/property-forms/first-step-two.js', 'public/js/property-forms')
   .js('resources/assets/js/property-forms/first-step-three.js', 'public/js/property-forms')
   .js('resources/assets/js/property-forms/first-step-four.js', 'public/js/property-forms')
   .js('resources/assets/js/property-forms/first-step-five.js', 'public/js/property-forms')
   .js('resources/assets/js/property-forms/second-step-one.js', 'public/js/property-forms')
   .js('resources/assets/js/property-forms/second-step-one-short-stay.js', 'public/js/property-forms')
   .js('resources/assets/js/property-forms/second-step-two.js', 'public/js/property-forms')
   .js('resources/assets/js/property-forms/fifth-step.js', 'public/js/property-forms')
   .js('resources/assets/js/property-forms/third-step-one.js', 'public/js/property-forms')
   .js('resources/assets/js/property-forms/four-step-one.js', 'public/js/property-forms')
   .js('resources/assets/js/property-forms/second-step-four.js', 'public/js/property-forms')
   .js('resources/assets/js/property-forms/photos-property.js', 'public/js/property-forms')
   .js('resources/assets/js/property-forms/schedule-property.js', 'public/js/property-forms')
   .js('resources/assets/js/property-forms/schedule_short_stay.js', 'public/js/property-forms')
   .js('resources/assets/js/property-forms/photos-project.js', 'public/js/property-forms')
   .js('resources/assets/js/service-forms/second-step-one.js', 'public/js/service-forms')
   .js('resources/assets/js/service-forms/second-step-two.js', 'public/js/service-forms')
   .js('resources/assets/js/service-forms/second-step-three.js', 'public/js/service-forms')
   .js('resources/assets/js/service-forms/second-step-four.js', 'public/js/service-forms')
   .js('resources/assets/js/agent-forms/first-step-three.js', 'public/js/agent-forms')
   .js('resources/assets/js/agent-forms/first-step-four.js', 'public/js/agent-forms')
   .js('resources/assets/js/agent-forms/second-step-three.js', 'public/js/agent-forms')
   .js('resources/assets/js/agent-forms/photo-company.js', 'public/js/agent-forms')
   .js('resources/assets/js/collateral-forms/first-step.js', 'public/js/collateral-forms')
   .js('resources/assets/js/memberships.js', 'public/js')
   .js('resources/assets/js/up.js', 'public/js')
   .js('resources/assets/js/explore.js', 'public/js')
   .js('resources/assets/js/explore-details.js', 'public/js')
   .js('resources/assets/js/agents-explore.js', 'public/js')
   .js('resources/assets/js/agents-details.js', 'public/js')
   .js('resources/assets/js/common-details.js', 'public/js')
   .js('resources/assets/js/services.js', 'public/js')
   .js('resources/assets/js/services-explore.js', 'public/js')
   .js('resources/assets/js/services-details.js', 'public/js')
   .js('resources/assets/js/contact.js', 'public/js')
   .js('resources/assets/js/referalls.js', 'public/js')
   .js('resources/assets/js/agents.js', 'public/js')
   .js('resources/assets/js/collaterals.js', 'public/js')
   .js('resources/assets/js/postulate.js', 'public/js')
   .js('resources/assets/js/publish.js', 'public/js')
   .js('resources/assets/js/tenant.js', 'public/js')
   .js('resources/assets/js/select_stay.js', 'public/js')
   .js('resources/assets/js/tenant_shortstay.js', 'public/js')
   .js('resources/assets/js/owners.js', 'public/js')
   .js('resources/assets/js/user-details.js', 'public/js')
   .js('resources/assets/js/agent-details.js', 'public/js')
   .js('resources/assets/js/profiles/*', 'public/js/profiles')
   .js('resources/assets/js/admin/main.js', 'public/js/admin')
   .sass('resources/assets/sass/app.scss', 'public/css')
   .sass('resources/assets/sass/register.scss', 'public/css')
   .sass('resources/assets/sass/landing.scss', 'public/css')
   .sass('resources/assets/sass/flujo.scss', 'public/css')
   .sass('resources/assets/sass/memberships.scss', 'public/css')
   .sass('resources/assets/sass/publish.scss', 'public/css')
   .sass('resources/assets/sass/aboutus.scss', 'public/css')
   .sass('resources/assets/sass/contact.scss', 'public/css')
   .sass('resources/assets/sass/referalls.scss', 'public/css')
   .sass('resources/assets/sass/postulate.scss', 'public/css')
   .sass('resources/assets/sass/explore.scss', 'public/css')
   .sass('resources/assets/sass/explore-details.scss', 'public/css')
   .sass('resources/assets/sass/agents-details.scss', 'public/css')
   .sass('resources/assets/sass/services.scss', 'public/css')
   .sass('resources/assets/sass/agents.scss', 'public/css')
   .sass('resources/assets/sass/photo-uploader.scss', 'public/css')
   .sass('resources/assets/sass/profiles.scss', 'public/css')
   .sass('resources/assets/sass/dx-components.scss', 'public/css')
   .sass('resources/assets/sass/errors.scss', 'public/css')
   .sass('resources/assets/sass/common-details.scss', 'public/css')
   .sass('resources/assets/sass/components/map_details.scss', 'public/css/components/map-details.css')
   .sass('resources/assets/sass/components/banner_gallery.scss', 'public/css/components/banner-gallery.css')
   .sass('resources/assets/sass/components/schedule.scss', 'public/css/components/schedule.css')
   .sass('resources/assets/sass/components/calculate.scss', 'public/css/components/calculate.css')
   .sass('resources/assets/sass/admin-panel/material-dashboard.scss', 'public/css/admin-panel')
   .sass('resources/assets/sass/only_tooltip.scss', 'public/css')
   .sass('resources/assets/sass/login-buttons.scss', 'public/css')
   .options({
        processCssUrls: false
    })
    .copy('node_modules/slick-carousel/slick/fonts/*', 'public/css/fonts')
    .copy('node_modules/font-awesome/fonts/*', 'public/css')
    .copy('node_modules/intl-tel-input/build/img/flags*', 'public/images')
    .copy('node_modules/intl-tel-input/build/js/utils.js', 'public/js/intTelInputUtils.js')
    .copy('node_modules/recordrtc/RecordRTC.js', 'public/js/recordrtc/RecordRTC.js')
    .copy('node_modules/bulma-carousel/dist/js/bulma-carousel.min.js', 'public/js')
    
;
