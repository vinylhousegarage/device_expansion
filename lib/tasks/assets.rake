# lib/tasks/assets.rake
namespace :assets do
  desc "Precompile assets using esbuild"
  task :precompile do
    puts "Running esbuild for assets..."

    system("yarn build") or raise "esbuild failed"

    FileUtils.mkdir_p('public/assets')

    FileUtils.cp_r('app/assets/builds/.', 'public/assets')

    puts "Assets precompiled successfully!"
  end
end
