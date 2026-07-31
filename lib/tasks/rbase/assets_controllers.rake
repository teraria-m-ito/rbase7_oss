# coding: utf-8
require "pathname"
require_relative '../support/rbase_task_helpers'

namespace :rbase do
  namespace :plugins do
    namespace :assets_controllers do
      desc "update customizing assets index.js"
      task :update => :environment do
        puts "[update_assets_controllers]start...."
        # javascriptの更新
        original_file_path = File.join(::Rails.root, "app", "javascript", "controllers", "index.js")
        temp_file_path = original_file_path + ".tmp"
        if File.exist?(temp_file_path)
          FileUtils.rm_f(temp_file_path)
        end

        puts "unregister javascript controller file on core part."
        index_custom_paths = Dir.glob(
          File.join(::Rails.root, "rbase_gems", "**/rbase_*", "app/javascript/controllers/index_custom.js")
        ).uniq
        customized_lines = {}
        index_custom_paths.each do |index_custom_path|
          File.open(index_custom_path) do |f2|
            f2.each_line do |line_to|
              customized_lines[line_to] = true
            end
          end
        end

        File.open(temp_file_path, 'a') do |f_tmp|
          File.open(File.join(original_file_path)) do |f1|
            f1.each_line do |line_from|
              if line_from.start_with? "// customizing javascript part."
                break
              end
              if line_from.blank?
                f_tmp.puts line_from
              else
                normalized_line = line_from.sub(/\A\/\/ customized /, "")
                found = customized_lines[normalized_line]
                if found
                  puts "=> #{normalized_line}"
                  f_tmp.puts "// customized #{normalized_line}"
                else
                  f_tmp.puts normalized_line
                end
              end
            end
          end
          f_tmp.puts "// customizing javascript part."

          # 並び変え
          if ENV["RBASE_GEMS_ORDER"].present?
            gems_index_custom_paths = []
            index_custom_paths.each do |index_custom_path|
              path_parts = RbaseTaskHelpers.extract_rbase_gem_path_parts(index_custom_path)
              gems_index_custom_paths << path_parts[0] if path_parts
            end

            if gems_index_custom_paths.present?
              sort_list = ENV["RBASE_GEMS_ORDER"].split(",").map(&:strip).reject(&:blank?)
              result =
                (sort_list & gems_index_custom_paths) +
                (gems_index_custom_paths - sort_list)

              sorted_index_custom_paths = index_custom_paths.sort_by.with_index do |path, original_index|
                idx = result.find_index { |key| path.include?(key.to_s) }
                idx.nil? ? [1, original_index] : [0, idx]
              end
              index_custom_paths = sorted_index_custom_paths
            end
          end

          # 並び変え後
          puts "index_custom_paths: #{index_custom_paths}"

          index_custom_paths.each do |index_custom_path|
            path_parts = RbaseTaskHelpers.extract_rbase_gem_path_parts(index_custom_path)
            next unless path_parts

            f_tmp.puts "import \"@app_root/rbase_gems/#{path_parts[0]}/#{path_parts[1]}\""
          end
        end
        FileUtils.mv(temp_file_path, original_file_path)

        # stylesheetsの更新
        puts "update css file......"
        custom_css_path = File.join(::Rails.root, "app/assets/stylesheets/custom")
        if File.exist?(custom_css_path)
          FileUtils.rm_f(custom_css_path)
        end

        gem_custom_css_path = []
        gem_custom_css_ln_path = []
        Dir.glob(File.join(::Rails.root, "rbase_gems", "rbase_*", "app/assets/stylesheets/custom.css")) do |css|
          gem_custom_css_path << css
        end

        gem_custom_css_path.each do |css_path|
          puts "target css file...... #{css_path}"
          plugin_name = RbaseTaskHelpers.extract_rbase_gem_name(css_path)

          if plugin_name
            ln_path = "#{custom_css_path}/#{plugin_name}.css"
            FileUtils.ln_sf(
              css_path,
              ln_path,
              :verbose => true
            )
            gem_custom_css_ln_path << ln_path
          end
        end

        # application.bootstrap.scssへの追加
        original_file_path = File.join(::Rails.root, "app", "assets", "stylesheets", "application.bootstrap.scss")
        temp_file_path = original_file_path + ".tmp"
        if File.exist?(temp_file_path)
          FileUtils.rm_f(temp_file_path)
        end

        puts "unregister stylesheets file on core part."

        File.open(temp_file_path, 'a') do |f_tmp|
          File.open(File.join(original_file_path)) do |f1|
            start_found = false
            end_found = false
            f1.each_line do |line_from|
              if line_from.start_with? "// customizing stylesheets part."
                start_found = true
                end_found = true
              end

              if line_from.start_with? "// for rbase"
                end_found = false
              end

              unless end_found
                f_tmp.puts line_from
              end

              if start_found
                f_tmp.puts "// customizing stylesheets part."
                gem_custom_css_ln_path.each do |ln_path|
                  css_filename = File.basename(ln_path)
                  f_tmp.puts "@import \"custom/#{css_filename}\";"
                end
                f_tmp.puts ""
                start_found = false
              end
            end
          end
        end
        FileUtils.mv(temp_file_path, original_file_path)

        # manifest.js に rbase_gems/rbase_*/app/assets/images の link_tree を反映
        puts "update manifest.js (rbase plugin images link_tree)......"
        manifest_path = File.join(::Rails.root, "app", "assets", "config", "manifest.js")
        manifest_dir = Pathname.new(File.expand_path(File.dirname(manifest_path)))

        image_suffixes = %w[.png .jpg .jpeg .gif .svg .ico .webp .bmp .avif].freeze

        # lib/customizes 側の実体は rbase_gems/rbase_* からのシンボリックリンクで参照する想定
        # （realpath に寄せると manifest が lib/... になり、不要に二重管理になる）
        images_dirs = Dir.glob(
          File.join(::Rails.root, "rbase_gems", "rbase_*", "app", "assets", "images")
        )
          .map { |p| File.expand_path(p) }
          .uniq
          .select { |p| File.directory?(p) }
        images_dirs.select! do |dir|
          Dir.glob(File.join(dir, "**", "*"), File::FNM_DOTMATCH).any? do |path|
            File.file?(path) && image_suffixes.include?(File.extname(path).downcase)
          end
        end

        if images_dirs.empty?
          puts "SKIP: manifest.js — rbase 用の images ディレクトリが見つかりません。"
          puts "  想定: #{::Rails.root}/rbase_gems/rbase_*/app/assets/images"
          puts "  少なくとも1件の画像（.png 等）があり、rbase_gems 配下にシンボリックリンクで繋いである必要があります。ブロックの削除も行いません。"
        else
        unless ENV["RBASE_GEMS_ORDER"].blank?
          gem_names = images_dirs.map { |p| RbaseTaskHelpers.extract_rbase_gem_name(p) }.compact
          sort_list = ENV["RBASE_GEMS_ORDER"].split(",").map(&:strip).reject(&:blank?)
          ordered_keys = (sort_list & gem_names) + (gem_names - sort_list)
          images_dirs = images_dirs.sort_by do |path|
            name = RbaseTaskHelpers.extract_rbase_gem_name(path)
            idx = ordered_keys.index(name)
            idx.nil? ? [1, path] : [0, idx]
          end
        else
          images_dirs.sort!
        end

        start_marker = "// BEGIN rbase plugins images link_tree"
        end_marker = "// END rbase plugins images link_tree"

        # 直前 run でブロック外に残した旧 rbase パス用 //= link を掃除
        plugin_image_link_re = %r{\A\s*//=\s+link\s+.*rbase_gems/rbase_[^/\s]+/app/assets/images/}

        plugin_link_tree_re = %r{\A\s*//=\s+link_tree\s+.*rbase_gems/rbase_[^\s/]+/app/assets/images\s*\z}

        lines = File.readlines(manifest_path)
        out_lines = []
        skipping = false
        lines.each do |line|
          if line.strip == start_marker
            skipping = true
            next
          end
          if skipping
            skipping = false if line.strip == end_marker
            next
          end
          next if plugin_link_tree_re.match?(line.chomp)
          next if plugin_image_link_re.match?(line.chomp)

          out_lines << line
        end
        if skipping
          puts "WARN: manifest.js の #{start_marker} に対応する #{end_marker} がありません。"
        end

        insertion_lines = []
        if images_dirs.any?
          insertion_lines << "#{start_marker}\n"
          images_dirs.each do |abs_dir|
            rel = Pathname.new(File.expand_path(abs_dir)).relative_path_from(manifest_dir).to_s.tr("\\", "/")
            insertion_lines << "//= link_tree #{rel}\n"
            image_paths =
              Dir.glob(File.join(abs_dir, "**", "*"), File::FNM_DOTMATCH).select do |path|
                File.file?(path) && image_suffixes.include?(File.extname(path).downcase)
              end.sort
            image_paths.each do |abs_file|
              # link_tree のディレクトリ通じて解決するため、ファイル名のみでよい
              insertion_lines << "//= link #{File.basename(abs_file)}\n"
            end
          end
          insertion_lines << "#{end_marker}\n"
        end

        merged = []
        inserted = insertion_lines.empty?
        anchor = "//= link_tree ../images"
        out_lines.each do |line|
          merged << line
          next if inserted

          if line.strip == anchor
            insertion_lines.each { |l| merged << l }
            inserted = true
          end
        end
        if !inserted && insertion_lines.any?
          puts "WARN: manifest.js に \"#{anchor}\" がありません。ファイル先頭へ rbase 画像 link_tree を挿入します。"
          merged = insertion_lines + merged
        end

        File.write(manifest_path, merged.join)
        end

        puts "[update_assets_controllers]finished...."
      end
    end
  end
end
