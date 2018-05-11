require 'sinatra'

set :env,  :production

configure do  
  set :root, File.dirname(__FILE__)
  disable :static 
  disable :logging
  enable :dump_errors 
  disable :sessions 
end

get '/' do 
  response['Cache-Control'] = "public, max-age=#{5*60*10}" 
  erb :index 
end 

post '/result/' do
  	params.delete 'submit'
  	@params = params
  	am_moth = params[:term].to_i
  	credit = params[:credit].to_f
  	percent_moth = params[:percent].to_f / 1200
  	ost_credit = credit

  	@table_result = []
 
  		for i in 1..am_moth do
  			if params[:payOff] == "Usual"
				one_moth_credit = credit / am_moth
				s_percent = ost_credit * percent_moth
  				suma = one_moth_credit + s_percent

			else
				suma = credit * (percent_moth + (percent_moth/((1+percent_moth)**am_moth-1)))
				s_percent = ost_credit * percent_moth
  				one_moth_credit = suma - s_percent
  		
			end	
			ost_credit -= one_moth_credit

			@value_hash = {nom_moth: i, s_credit: one_moth_credit.round(2), ost_credit: ost_credit.round(2), 
				s_percent: s_percent.round(2), suma: suma.round(2)}
			@table_result << @value_hash 
  		end

  	erb :result
end

