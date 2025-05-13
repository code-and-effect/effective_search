module Admin
  class EffectiveSearchContentsDatatable < Effective::Datatable
    datatable do
      order :updated_at, :desc

      col :id, visible: false
      col :created_at, visible: false
      col :updated_at, visible: false

      col :title
      col :url
      col :keywords
      col :rich_text_body, label: 'Body', visible: false
      col :file, visible: false

      actions_col
    end

    collection do
      Effective::SearchContent.deep.all
    end
  end
end
