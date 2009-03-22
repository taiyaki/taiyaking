class ShopsController < ApplicationController
  before_filter :block_until_authorized,
    :only => [:new, :edit, :create, :update, :destory]

  def index
    @shops = Shop.paginate(:page => params[:page], :order => "updated_at DESC", :per_page => 5)
    @title = "Shop - たいやきる？"
  end

  def new
    @shop = Shop.new
    @title = "たいやき店情報作成 - たいやきる？"
  end

  def create
    @shop = Shop.new(params[:shop])
    if @shop.save
      flash[:notice] = '新しいお店を追加しました'
      redirect_to(@shop)
    else
      render :action => "new"
    end
  end

  def show
  end

  def edit
  end
end
