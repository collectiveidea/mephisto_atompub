class AtompubController < ApplicationController
  include AuthenticatedSystem
  before_filter :basic_auth_required, :find_section, :except => [:servicedoc]

  layout nil
  session :off
  
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
    article = Article.new(atom_params)
    article.updater = current_user
    article.site = site
    current_user.articles << article
    article.sections << @section
    render :partial => "article", :locals => {:article => article}, :status => :created, :location => "http://#{request.host_with_port}#{request.relative_url_root}#{section_url_for article}"
  end
  
private

  # Fix mephisto to store current user when authenticating with basic auth
  def basic_auth_required
    self.current_user = super
  end
  
  def find_section
    @section = site.sections.find_by_path(params[:sections].join('/'))
  end
  
  def atom_params
    atom = XmlSimple.xml_in(request.body, "ForceArray" => false)
    {
      :title => atom["title"]["content"],
      :body => atom["content"]["content"],
      :published_at => atom["control"] && atom["control"]["draft"] == "no" ? Time.now : nil
    }
  end
  
end