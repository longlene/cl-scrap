#!/usr/bin/ruby

require 'open-uri'
require 'json'

class RubyEbuild
        PORTDIRS=%w(/usr/portage /usr/local/portage /var/lib/layman/ /home/clx/ruby-overlay .)
        attr_accessor :json, :name, :version, :comment, :eapi, :description, :homepage, :src_uri, :licenses, :slot, :keywords, :iuse, :depend, :rdepend

        def initialize(name)
                @name = name
                @comment = "# Distributed under the terms of the GNU General Public License v2"
                @eapi = 5
                @description = ""
                @homepage = ""
                @src_uri = ""
                @licenses = []
                @slot = "0"
                @keywords = ["~x86", "~amd64"]
                @iuse = []
                @depend = []
                @rdepend = []
        end

        def gem_exist?
                search_uri = "https://rubygems.org/api/v1/search.json?query="
                open(search_uri + @name) do |http|
                        content = http.read
                        json = JSON.parse(content)
                        json.each do |item|
                                return true if item["name"] == @name
                        end
                end
                false
        end

        def exist?
                PORTDIRS.each do |dir|
                        return true if File.exist? "#{dir}/dev-ruby/#{@name}/#{@name}-#{@version}.ebuild"
                end
                false
        end

        def to_s
                s = ""
                s << @comment << "\n\n"
                s << "EAPI=#{@eapi}\n"
                s << "USE_RUBY=\"ruby19 ruby20 ruby21\"\n\n"
                s << "RUBY_FAKEGEM_TASK_DOC=\"\"\n"
                s << "RUBY_FAKEGEM_EXTRADOC=\"README.md\"\n"
                s << "RUBY_FAKEGEM_GEMSPEC=\${PN}.gemspec\n\n"
                s << "inherit ruby-fakegem\n\n"
                s << "DESCRIPTION=\"#{@description}\"\n"
                s << "HOMEPAGE=\"#{@homepage}\"\n\n"
                if @licenses == nil || @licenses.length == 0
                        s << "LICENSE=\"\"\n"
                else
                        s << "LICENSE=\"#{@licenses.join(" ")}\"\n"
                end
                s << "SLOT=\"#{@slot}\"\n"
                s << "KEYWORDS=\"#{@keywords.join(" ")}\"\n"
                s << "IUSE=\"#{@iuse.join(" ")}\"\n\n"

                @rdepend.each do |x|
                        name = x["name"]
                        req = x["requirements"]
                        s << "ruby_add_rdepend \""
                        if req.include?("=") || req.include?(">")
                                s << req.match(/(>=|~>|>|=)[\s]{1}[\d]+(\.[\d]+)*/)[0].sub(" ", "dev-ruby/#{name}-")
                        else
                                s << "dev-ruby/#{name}"
                        end
                        s << "\"\n"
                end
                s << "\n"
        end

        def get
                gem_uri = "https://rubygems.org/api/v1/gems/#{@name}.json"
                open(gem_uri) do |http|
                        content = http.read
                        @json = JSON.parse(content)
                        #puts "@json: #{@json}"
                        @version = @json["version"]
                        @description = @json["info"]
                        @licenses = @json["licenses"]
                        @homepage = @json["homepage_uri"]
                        @rdepend = @json["dependencies"]["runtime"]
                end

        end

        def generate
                path = "dev-ruby"
                ebuild_dir = path + "/" + @name
                Dir.mkdir(path) unless Dir.exist?(path)
                Dir.mkdir(ebuild_dir) unless Dir.exist?(ebuild_dir)
                ebuild_file = ebuild_dir + "/" + "#{@name}-#{@version}.ebuild"
                metafile = ebuild_dir + "/" + "metadata.xml"
                #jsonfile = ebuild_dir + "/" + "ebuild.json"
                File.open(ebuild_file, "w") do |file|
                        file.print(to_s)
                end

                unless File.exist?(metafile)
                        File.open(metafile, "w") do |file|
                                file.print(metadata)
                        end
                end

                #File.open(jsonfile, "w") do |file|
                #        file.print(@json)
                #end

                File.open("mask.list", "a+") do |file|
                        file.puts("#-----------------------------------")
                        file.puts("##{Time.now}")
                        file.puts("=dev-ruby/#{@name}-#{@version}")
                end
        end

        def metadata
                author = "loong0"
                email = "longlene@gmail.com"
                tool = "gbuild.rb"
                s = ""
                s << "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
                s << "<!DOCTYPE pkgmetadata SYSTEM \"http://www.gentoo.org/dtd/metadata.dtd\">\n"
                s << "<pkgmetadata>\n"
                s << "<maintainer>\n"
                s << "<name>#{author}</name>\n"
                s << "<email>#{email}</email>\n"
                s << "<tool>#{tool}</tool>\n"
                s << "</maintainer>\n"
                s << "<longdescription>\n"
                s << "#{@description}\n"
                s << "</longdescription>\n"
                s << "</pkgmetadata>\n"
        end
end

if $0 == __FILE__
        exit 1 if ARGV.length < 1

        ARGV.each do |name|
                puts "---------------------------------------------------"
                ebuild = RubyEbuild.new(name)
                #if ebuild.gem_exist?
                #        puts "[INFO] gem: #{ebuild.name} exist"

                ebuild.get
                #puts ebuild.to_s

                if ebuild.exist?
                        puts "[WARN] ebuild: #{ebuild.name} exists"
                        next
                else
                        puts "[INFO] ebuild: #{ebuild.name} not exist"
                        puts "[INFO] ebuild: generating ebuild for #{ebuild.name} ..."
                        ebuild.generate
                        puts "[INFO] ebuild: dev-ruby/#{ebuild.name}-#{ebuild.version} generated"
                end
                #else
                #        puts "[ERROR] gem: #{ebuild.name} not exist"
                #end
                sleep 5
        end
end
