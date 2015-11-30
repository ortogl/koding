kd                    = require 'kd'
React                 = require 'kd-react'
ReactDOM              = require 'react-dom'
classnames            = require 'classnames'
immutable             = require 'immutable'
EmojiSelectorItem     = require 'activity/components/emojiselectoritem'
ImmutableRenderMixin  = require 'react-immutable-render-mixin'
List                  = require 'app/components/list'

module.exports = class EmojiSelectorList extends React.Component

  @defaultProps =
    items        : immutable.List()


  numberOfSections: ->

    return @props.items.size


  numberOfRowsInSection: (sectionIndex) ->

    return @props.items.getIn([sectionIndex, 'emojis']).size


  sectionId: (sectionIndex) ->

    category = @props.items.getIn [sectionIndex, 'category']
    return "EmojiSelectorCategory-#{kd.utils.slugify category}"


  renderSectionHeaderAtIndex: (sectionIndex) ->

    category = @props.items.getIn [sectionIndex, 'category']
    <header className='EmojiSelector-categorySectionHeader'>{category}</header>


  renderRowAtIndex: (sectionIndex, rowIndex) ->

    { items } = @props

    emojis     = items.getIn [sectionIndex, 'emojis']
    item       = emojis.get rowIndex

    result = [<EmojiSelectorItem
      item         = { item }
      index        = { helper.calculateTotalIndex items, sectionIndex, rowIndex }
      onSelected   = { @props.onItemSelected }
      onUnselected = { @props.onItemUnselected }
      onConfirmed  = { @props.onItemConfirmed }
      key          = { item }
    />]
    result.push <div className='clearfix' key='clearfix' />  if rowIndex is emojis.size - 1

    return result


  renderEmptySectionAtIndex: (sectionIndex) ->

    <div className='EmojiSelector-emptyCategory'>No emoji found</div>


  render: ->

    <List
      numberOfSections={@bound 'numberOfSections'}
      numberOfRowsInSection={@bound 'numberOfRowsInSection'}
      renderSectionHeaderAtIndex={@bound 'renderSectionHeaderAtIndex'}
      renderRowAtIndex={@bound 'renderRowAtIndex'}
      sectionClassName='EmojiSelector-categorySection'
      sectionId={@bound 'sectionId'}
      renderEmptySectionAtIndex={@bound 'renderEmptySectionAtIndex'}
    />


  helper =

    calculateTotalIndex: (categoryItems, categoryIndex, emojiIndex) ->

      categoryItems = categoryItems.toJS()
      totalIndex    = emojiIndex

      for categoryItem, index in categoryItems when index < categoryIndex
        totalIndex += categoryItem.emojis.length

      return totalIndex


EmojiSelectorList.include [ImmutableRenderMixin]

