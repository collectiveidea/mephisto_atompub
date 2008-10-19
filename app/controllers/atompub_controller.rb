class AtompubController < ApplicationController
  include AuthenticatedSystem
  before_filter :basic_auth_required, :only => [:add_entry_to_collection]

  layout nil
  session :off
  
  before_filter :find_section, :except => [:servicedoc]
  # cache_sweeper :article_sweeper, :assigned_section_sweeper, :comment_sweeper

  def servicedoc
    @sections = site.sections
    headers['Content-Type'] = 'application/atomsvc+xml; charset=utf-8'
  end

  def index
    headers['Content-Type'] = 'application/atom+xml; charset=utf-8'
    @articles = @section.articles.find_by_date(:limit => 15, :include => :user)
  end

  def create
    article = Article.from_atom(request.body)
    article.updater = current_user
    article.site = site
    current_user.articles << article
    article.sections << @section
    render :partial => "article", :locals => {:article => article}, :status => :created, :location => "http://#{request.host_with_port}#{request.relative_url_root}#{section_url_for article}"
  end
  
private
  
  def find_section
    @section = site.sections.find_by_path(params[:sections].join('/'))
  end
  
end