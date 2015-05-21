module TestGroupsHelper

  def render_tree(list, &block)
    list = (list.is_a? TestGroup) ? [list] : list
    "<ul class='children'>
      #{
        list.map do |item|
          "<li>#{capture(item, &block)} #{render_tree(item.children, &block)}</li>"
        end.join
      }
    </ul>".html_safe if list
  end

end
