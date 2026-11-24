require 'spec_helper'

describe DocumentIssuesController do
  describe "GET current" do
    it "reuses the table of contents documents for the issue presenter" do
      date = Date.new(2026, 11, 24)
      documents = [double('document')]
      toc_presenter = instance_double(TableOfContentsPresenter, documents: documents)

      allow(DocumentIssue).to receive(:current).and_return(double(publication_date: date))
      allow(TableOfContentsPresenter).to receive(:new).with(date).and_return(toc_presenter)
      expect(DocumentIssuePresenter).to receive(:new).
        with(date, {current_issue: true, documents: documents}).
        and_call_original
      expect(Document).not_to receive(:search)
      allow(controller).to receive(:render) { controller.head(:ok) }

      get :current

      expect(controller).to have_received(:render).with(:show)
    end
  end
end
