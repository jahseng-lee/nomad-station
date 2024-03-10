module SearchLocationsHelper
  TAG_NAME_TO_ICON_CLASS = {
    "Beach" => "bi-brightness-alt-high-fill",
    "Cheap" => "bi-piggy-bank-fill",
    "Food" => "bi-cup-hot-fill",
    "History" => "bi-bank",
    "Hot" => "bi-thermometer-half",
    "Nature" => "bi-tree-fill",
    "Party" => "bi-cup-straw",
    "Popular" => "bi-fire",
    "Quiet" => "bi-mic-mute-fill",
    "Remote" => "bi-compass",
    "Safe" => "bi-cone-striped",
    "Shopping" => "bi-bag-fill",
    "Ski/snowboard" => "bi-snow",
    "Surf" => "bi-tsunami",
    "Yoga" => "bi-person-arms-up",
  }

  def helper_filter_button_icon(tag_name:)
    "<i aria-hidden='true' class='bi #{TAG_NAME_TO_ICON_CLASS[tag_name]}'></i>".html_safe
  end
end
