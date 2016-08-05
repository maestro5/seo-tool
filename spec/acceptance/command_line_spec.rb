require_relative '../acceptance_helper'

feature 'User command line', %q{
  As an user
  I want to be able to command line interface
} do

  scenario 'when reports list empty' do
    output = `./bin/seo list`
    expect(output).to have_content 'There are no reports!'
  end

  scenario 'when creates a report with invalid url' do
    url = 'nonamecom'
    output = `./bin/seo parse #{url}`
    expect(output).to have_content "Url \'#{url}\' has an invalid format!"
  end

  scenario 'when creates a report with valid url' do
    2.times do
      output = `./bin/seo parse http://github.com`
      expect(output).to have_content 'Report for http://github.com was created'
      sleep(1)
    end
  end

  scenario 'when shows a reports list' do
    output = parse_output(`./bin/seo list`)
    expect(output[0]).to have_content 'Created'
    expect(output[1]).to have_content 'github.com'
    expect(output[2]).to have_content 'github.com'
  end

  scenario 'when shows an invalid report' do
    id = 7
    output = `./bin/seo show #{id}`
    expect(output).to have_content "Report with id: #{id} does not exist!"
  end

  scenario 'when shows a valid report with short id' do
    output = parse_output(`./bin/seo list`)
    id     = output[1][0]

    output = `./bin/seo show #{id}`
    expect(output).to have_content 'Report for http://github.com'
  end

  scenario 'when shows a valid report with long id' do
    output = parse_output(`./bin/seo list`)
    id     = output[1][-1]

    output = `./bin/seo show #{id}`
    expect(output).to have_content 'Report for http://github.com'
  end
end # User command line
