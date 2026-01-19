module Admin
  class EffectiveSearchDatatable < Effective::Datatable
    datatable do
      col :term, label: "&nbsp;".html_safe
    end

    collection do
      results = []

      if search[:term].present?
        [
          ['one'],
          ['two'],
          ['three']
        ]
      else
        results
      end
    end
  end
end
