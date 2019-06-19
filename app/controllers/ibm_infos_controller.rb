class IbmInfosController < ApplicationController
  before_action :set_ibm_info, only: [:show, :update, :destroy]

  # GET /ibm_infos
  def index
    @ibm_infos = IbmInfo.all

    render json: @ibm_infos
  end

  # GET /ibm_infos/1
  def show
    render json: @ibm_info
    
  end

  # POST /ibm_infos
  def create
    @ibm_info = IbmInfo.new(ibm_info_params)
    # WebDriver Options ...
    options = Selenium::WebDriver::Chrome::Options.new
    chrome_bin_path = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
    puts '********* chrome_bin_path ---> '
    puts chrome_bin_path
    options.binary = chrome_bin_path if chrome_bin_path # only use custom path on heroku
    options.add_argument('--headless') # this may be optional
    driver = Selenium::WebDriver.for :chrome, options: options
    b = Watir::Browser.new(:chrome, {:chromeOptions => {:args => ['--headless', '--window-size=1200x600']}})
    ibm_login_url = 'https://www.ibm.com/account/reg/us-en/login?formid=urx-34710'
    b.goto(ibm_login_url)

    b.text_field(name: 'ibmid').set @ibm_info.IBMid
    b.button(type: 'submit').click
    b.text_field(name: 'password').set @ibm_info.password
    b.button(type: 'submit').click

    sleep 5
    b.button(type: 'submit').click
    sleep 5

    b.div(title: '‪sample product report‬').click
    sleep 20
    r_html = b.html
    @ibm_info.report_xml = Nokogiri::HTML.parse(r_html)
    b.close

    if @ibm_info.save
      render json: @ibm_info, status: :created, location: @ibm_info
    else
      render json: @ibm_info.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /ibm_infos/1
  def update
    if @ibm_info.update(ibm_info_params)
      render json: @ibm_info
    else
      render json: @ibm_info.errors, status: :unprocessable_entity
    end
  end

  # DELETE /ibm_infos/1
  def destroy
    @ibm_info.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ibm_info
      @ibm_info = IbmInfo.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def ibm_info_params
      params.require(:ibm_info).permit(:IBMid, :password, :report_name, :report_xml)
    end
end
