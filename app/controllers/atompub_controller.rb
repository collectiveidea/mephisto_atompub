require 'atom/entry'

class AtompubController < ApplicationController
  include AuthenticatedSystem
  skip_before_filter :login_required
  before_filter :basic_auth_required, :except => [:servicedoc, :index]
  before_filter :find_section, :except => [:servicedoc, :show]

  layout nil
  session :off
  
  # cache_sweeper :article_sweeper, :assigned_section_sweeper, :comment_sweeper

  def servicedoc
    @sections = site.sections
    render :content_type => 'application/atomsvc+xml; charset=utf-8'
  end

  def index
    @articles = @section.articles.find_by_date(:limit => 15, :include => :user)
    render :content_type => 'application/atom+xml; charset=utf-8'
  end

  def create
    article = current_user.articles.create!(atom_params.merge(:updater => current_user, :site => site))
    article.section_ids = [@section.id]
    render :partial => "article", :locals => {:article => article}, :status => :created,
      :content_type => 'application/atom+xml; charset=utf-8',
      :location => collection_entry_url(article)
  end
  
  def show
    article = @site.articles.find(params[:id])
    render :partial => "article", :locals => {:article => article},
      :content_type => 'application/atom+xml; charset=utf-8'
  end
  
private

  # Fix mephisto to store current user when authenticating with basic auth
  def basic_auth_required
    self.current_user = super
  end
  
  def find_section
    @section = site.sections.find_by_path(params[:sections].join('/')) || raise(ActiveRecord::RecordNotFound, "Could not find section for #{params[:sections].inspect}")
  end
  
  def atom_params
    # debugger
    entry = Atom::Entry.parse(request.raw_post)
    {
      :title => entry.title.to_s,
      :body => entry.content.to_s,
      :published_at => entry.draft? ? nil : Time.now
    }
  end
  
  helper_method :section_url_for
  def section_url_for(article)
    if @section && @section.show_paged_articles?
      @section_articles ||= {}
      @section_articles[@section.id] ||= (@section.articles.find(:first) || :false)
      ([nil] << (@section_articles[@section.id].permalink == article.permalink ? @section.to_url : @section.to_page_url(article))).join("/")
    else
      site.permalink_for(article)
    end
  end
  
end