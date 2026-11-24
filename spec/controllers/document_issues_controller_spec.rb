require 'spec_helper'

describe DocumentIssuesController do
  describe "GET current" do
    it "builds the issue summary from the table of contents documents without a second search" do
      date = Date.new(2026, 11, 24)
      documents = [
        double('document', start_page: 100, end_page: 104,
          excluding_parent_agencies: [double('agency', id: 1)]),
        double('document', start_page: 105, end_page: 120,
          excluding_parent_agencies: [double('agency', id: 2), double('agency', id: 1)])
      ]
      toc_presenter = instance_double(TableOfContentsPresenter, documents: documents)

      allow(DocumentIssue).to receive(:current).and_return(double(publication_date: date))
      allow(TableOfContentsPresenter).to receive(:new).with(date).and_return(toc_presenter)
      expect(Document).not_to receive(:search)
      allow(controller).to receive(:render) { controller.head(:ok) }

      get :current

      expect(controller).to have_received(:render).with(:show)
      doc_presenter = controller.instance_variable_get(:@doc_presenter)
      expect(doc_presenter.document_count).to eq(2)
      expect(doc_presenter.agency_count).to eq(2)
      expect(doc_presenter.page_count).to eq(21)
    end
  end
end
