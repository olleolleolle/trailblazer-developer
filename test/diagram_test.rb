require "test_helper"


require "trailblazer/developer"
require "trailblazer/diagram/bpmn"
require "trailblazer/circuit"

class DiagramXMLTest < Minitest::Spec
  Circuit = Trailblazer::Circuit

  module Blog
    Read    = ->(*) { snippet }
    Next    = ->(*) { snippet }
    Comment = ->(*) { snippet }
  end

  let(:blog) do
    Circuit::Activity(id: "blog.read/next", Blog::Read=>:Read, Blog::Next=>:Next, Blog::Comment=>:Comment) { |evt|
      {
        evt[:Start]  => { Circuit::Right => Blog::Read },
        Blog::Read => { Circuit::Right => Blog::Next },
        Blog::Next => { Circuit::Right => evt[:End], Circuit::Left => Blog::Comment },
        Blog::Comment => { Circuit::Right => evt[:End] }
      }
    }
  end

  it do
    puts Trailblazer::Diagram::BPMN.to_xml(blog)
  end
end