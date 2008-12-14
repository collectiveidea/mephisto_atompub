require 'atom/entry'

class Atompub::AssetsController < AtompubController
  before_filter :basic_auth_required
  
  def index
    @assets = @site.assets.paginate(:order => 'assets.updated_at DESC', 
      :page => params[:page], :per_page => 15)
    
    render :content_type => 'application/atom+xml;type=feed;charset=utf-8'
  end

  def create
    @asset = site.assets.create!(:user_id => current_user.id, :uploaded_data => uploaded_data)
    render :action => 'show', :status => :created, :location => atompub_asset_url(@asset),
      :content_type => 'application/atom+xml;type=entry;charset=utf-8'
  end
  
  def show
    @asset = site.assets.find(params[:id])
    respond_to do |wants|
      wants.atom
      wants.any { redirect_to @asset.public_filename }
    end
  end
  
  def update
    @asset = site.assets.find(params[:id])
    respond_to do |wants|
      wants.atom do
        entry = Atom::Entry.parse(request.raw_post)
        @asset.title = entry.title.to_s if entry.title
        @asset.tag = entry.categories.map(&:term).join(', ') unless entry.categories.blank?
      end
      wants.any do
        data = uploaded_data
        data['filename'] ||= @asset.filename
        @asset.uploaded_data = data
      end
    end
    @asset.save!
    render :nothing => true
  end

private

  def uploaded_data
    {
      'tempfile' => StringIO.new(request.raw_post),
      'size' => request.content_length,
      'content_type' => request.content_type,
      'filename' => request.headers['Slug']
    }
  end

end