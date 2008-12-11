class Atompub::AssetsController < AtompubController
  before_filter :basic_auth_required

  def create
    @asset = site.assets.create!(:user_id => current_user.id,
      :uploaded_data => {
        'tempfile' => StringIO.new(request.raw_post),
        'size' => request.content_length,
        'content_type' => request.content_type,
        'filename' => request.headers['Slug']
      }
    )
    render :action => 'show', :status => :created, :location => atompub_asset_url(@asset),
      :content_type => 'application/atom+xml;type=entry;charset=utf-8'
  end

end