// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import ChatChannelController from "./chat_channel_controller"
application.register("chat-channel", ChatChannelController)

import ChatTextareaController from "./chat_textarea_controller"
application.register("chat-textarea", ChatTextareaController)

import JoinableChannelListController from "./joinable_channel_list_controller"
application.register("joinable-channel-list", JoinableChannelListController)

import LoadMoreController from "./load_more_controller"
application.register("load-more", LoadMoreController)

import LocationTabsController from "./location_tabs_controller"
application.register("location-tabs", LocationTabsController)

import ModalController from "./modal_controller"
application.register("modal", ModalController)

import NavbarLinkController from "./navbar_link_controller"
application.register("navbar-link", NavbarLinkController)

import SearchCountriesController from "./search_countries_controller"
application.register("search-countries", SearchCountriesController)

import SearchLocationsController from "./search_locations_controller"
application.register("search-locations", SearchLocationsController)
