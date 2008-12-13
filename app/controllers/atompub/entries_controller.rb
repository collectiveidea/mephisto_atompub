require 'atom/entry'

class Atompub::EntriesController < AtompubController
  before_filter :basic_auth_required, :except => [:servicedoc, :categories]
  before_filter :find_section, :only => [:index, :create]
  # cache_sweeper :article_sweeper, :assigned_section_sweeper, :comment_sweeper

  def servicedoc
    @sections = site.sections
    render :content_type => 'application/atomsvc+xml; charset=utf-8'
  end
  
  def categories
    @tags = site.tags
    render :content_type => 'application/atomcat+xml'
  end

  def index
    @articles = @section.articles.by_date.paginate(:page => params[:page], :per_page => 15, :include => :user)
    
    render :content_type => 'application/atom+xml;type=feed;charset=utf-8'
  end

  def show
    @article = @site.articles.find(params[:id])
    render :action => "show", :content_type => 'application/atom+xml;type=entry;charset=utf-8'
  end
  
  def create
    @article = current_user.articles.create!(atom_params.merge(:updater => current_user, :site => site))
    @article.section_ids = [@section.id]
    render :action => "show", :status => :created,
      :content_type => 'application/atom+xml;type=entry;charset=utf-8',
      :location => collection_entry_url(@article)
  end
  
  def update
    @article = @site.articles.find(params[:id])
    render :action => "show", :content_type => 'application/atom+xml;type=entry;charset=utf-8'
  end
  
  def destroy
    @article = @site.articles.find(params[:id])
    @article.destroy
    render :nothing => true, :status => 200
  end

private

  def find_section
    @section = site.sections.find_by_path(params[:sections].join('/')) || raise(ActiveRecord::RecordNotFound, "Could not find section for #{params[:sections].inspect}")
  end
  
  def atom_params
    entry = Atom::Entry.parse(request.raw_post)
    {
      :title => entry.title.to_s,
      :body => entry.content.to_s,
      :published_at => entry.draft? ? nil : Time.now,
      :tag => entry.categories.map(&:term).join(', ')
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