class Github

	require 'rubygems'
	require 'nokogiri'
	require 'open-uri'
	require 'date'
	require_relative '../utils.rb'
	include Utils

	MONTH_NO_UPDATE = 6

	def initialize(url='',version='')

		if url.index("github.com")
			@url = url
		else
			@url = "https://github.com/" + url
		end

		@version = version

	end

	def check()

                release = lastRelease()
                commit = lastCommit()
                rd = releaseDate().to_i
                now = Time.now.strftime("%Y%m").to_i
		
		# check date 201601 vs 201511
		year = now/100 - rd/100 # 2016 - 2015
		mo = now - now/100*100 # 201601 - 201600 = 01
		# 201601 vs 201511, handle the year
		if year > 0
			diff = year*12 + mo - (rd - rd/100*100) # 01*12 + 01 - (201511 - 201500)
		else
			diff = now - rd
		end

                if ( @version == "nil" || @version.empty? )
                        if release
                                return release
                        else
                                return commit
                        end
		elsif diff > MONTH_NO_UPDATE

                       	return commit

                else

                        return release

                end
	
	end

	def lastRelease()

		release = Nokogiri::HTML(open(@url + '/releases')).xpath('//ul[@class="release-timeline-tags"]/li[1]/div/div/h3/a/span').text

		return release

	end

	def releaseDate()
		url = @url + "/releases"
		html = Nokogiri::HTML(open(url))
		# with release notes or not
		unless html.css('p.release-authorship').empty?
			#"Nov 18, 2015"
			raw = html.css('p.release-authorship')[0].css('time').text
			da = raw.split(' ')
			da[0] = returnMonth(da[0])
			da[1] = da[1].gsub(',','')
			dstring = da[2] + "-" + da[0] + "-" + da[1]
		else
			#"2015-12-22T08:05:43Z"
			ds = html.css('ul.release-timeline-tags')[0].css('li')[0].css('span.date time').xpath('@datetime').first.value
			dstring = ds.split('T')[0]		
		end

		darray = dstring.split('-')
		date = darray[0] + darray[1]
		return date
	end

	def lastCommit()

		commit = Nokogiri::HTML(open(@url + '/commits/master')).xpath('//ol[contains(@class,"commit-group")]/li[1]/div[3]/div/a').first.text.strip!

		date = commitDate()

		if ( @version == "nil" || @version.empty? )

			prefix = "0.0.0"

		else

			prefix = @version.gsub(/\+.*$/,'')

		end

		version = prefix + "+git" + date + '.' + commit

		return version

	end

	def commitDate()

		dstring = Nokogiri::HTML(open(@url + '/commits/master')).xpath('//div[@class="commit-group-title"]').first.text.strip!

		x = dstring.gsub(/^.*on\s/,'').split(',')

		year = x[1].strip!

		y = x[0].split(/\s/)	

		month = returnMonth(y[0])

		day = y[1]

		date = year + month + day

		return date

	end

end

