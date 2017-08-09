require 'Webshot'

ws = Webshot::Screenshot.instance

# TODO required modification to capybara/node/finders.rb and capybara/node/actions.rb possibly make a subclass and override methods

ws.start_session do
  visit 'private/uploads/grabConsole.html'
  fill_in 'flag', with: 'password'
  width = 1920
  height = 1080
  path = 'anotherTest.png'
  driver.save_screenshot(path, width: width, height: height, full: true, background: 'white')
  thumb = MiniMagick::Image.open('anotherTest.png')
  if block_given?
    yield thumb
  else
    thumb.combine_options do |c|
      c.thumbnail "#{width}x"
      c.background 'white'
      c.extent "#{width}x#{height}"
      c.gravity 'north'
      c.quality 85
    end
  end
  thumb.write path
  thumb
end