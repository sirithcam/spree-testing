# frozen_string_literal: true

module AdminHelper
  def find_admin_item(name)
    visit Router.new.admin_products_path
    fill_in 'Quick search..', with: name
    # There is no button in search field so we need to hit enter
    find('#quick_search').send_keys :enter

    wait_for { page.has_css?('a', text: /\A#{name}\z/) }

    # Find exact text
    find('a', text: /\A#{name}\z/).click

    wait_for { page.has_css?('#s2id_product_taxon_ids') }
  end
end
