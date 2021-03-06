class CocoaPodCategoryUpdater
  attr_reader :categories_import

  def initialize categories_import=CocoaPodsCategoriesImport.new
    @categories_import = categories_import
  end

  def update cocoa_pod
    category_name = categories_import[cocoa_pod.name]
    if category_name.present?
      category = cocoa_pod.cocoa_pod_category
      if category
        if category.name == category_name
          Rails.logger.info "Keeping #{cocoa_pod.name} in #{category_name}"
        else
          Rails.logger.info "Moving #{cocoa_pod.name} to #{category_name} "\
                            "(from #{category.name})"
          move cocoa_pod, category_name
        end
      else
        Rails.logger.info "Moving #{cocoa_pod.name} to #{category_name}"
        move cocoa_pod, category_name
      end
    end
  end

  def move cocoa_pod, category_name
    cocoa_pod.category_name = category_name
    cocoa_pod.save!
    category = CocoaPodCategory.find(category_name) || CocoaPodCategory.new(name: category_name)
    category.cocoa_pods << cocoa_pod.name
    category.save!
  end
end
