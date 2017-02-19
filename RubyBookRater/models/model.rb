class Model < ActiveRecord::Base
	def getAverage(param)
	    avgRatings = Model.find_by_sql(["select name,avg(rating) from models group by name order by avg(rating) desc"])
	end
end