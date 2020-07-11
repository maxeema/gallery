import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maxeem_gallery/domain/photo.dart';
import 'package:maxeem_gallery/localizations/localization.dart';
import 'package:maxeem_gallery/misc/ext.dart';
import 'package:maxeem_gallery/misc/util.dart';
import 'package:maxeem_gallery/ui/ui.dart' as ui;
import 'package:share/share.dart';

const _avatarSize = 128;
const _maxWidth = 300;

class DetailsScreen extends StatefulWidget {

  final Photo photo;

  const DetailsScreen(this.photo);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();

}

class _DetailsScreenState<T extends DetailsScreen> extends State<T> with LocalizableState<T> {

  Photo get photo => widget.photo;

  var _isExpanded = false;

  _createPhotoInfo() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[

            Expanded(
              child: InkResponse(
                onTap: () => launchUrl(photo.htmlUrl),
                onLongPress: ()=> copyToClipboard(photo.htmlUrl, ctx: context, toastMsg: l.copied),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    photo.htmlUrl.leaveMandatoryUrl(),
                    style: theme.textTheme.body1.apply(
                        color: Colors.blue
                    ),
                  )
                )
              )
            ),

            InkResponse(
              onTap: () => Share.share(photo.htmlUrl),
              child: Tooltip(
                message: l.share,
                child: Padding(
                  padding: EdgeInsets.only(top: 4, bottom: 4, left: 4, right: 0),
                  child: Icon(
                    Icons.share,
                    color: Colors.black.withAlpha(0x77),
                    size: 18,
                  ),
                )
              ),
            )
          ],
        ),

        if (isNotEmpty(photo.description))
          Text(
            photo.description.trim(),
            textAlign: TextAlign.center,
            maxLines: _isExpanded ? 10 : 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.body1.apply(
              color: Colors.grey.shade500
            ),
          ),
      ],
    );
  }
  _createAvatar({large = false}) {
    final author = widget.photo.author;
    final avatarUrl = prepareAvatarUrl(window, _avatarSize, author.avatarUrl);
    return InkResponse(
      onTap:       isNotEmpty(author.unsplashUrl) ? () => launchUrl(author.unsplashUrl) : null,
      onLongPress: isNotEmpty(author.unsplashUrl) ? () =>
          copyToClipboard(author.unsplashUrl, ctx: context, toastMsg: l.authorPageCopied) : null,
      child: CircleAvatar(
        maxRadius: _avatarSize / (large ? 2 : 4),
        backgroundImage: NetworkImage(avatarUrl),
      ),
    );
  }

  _createAuthorTile() {
    final theme = Theme.of(context);
    final author = widget.photo.author;
    return Row(
      children: <Widget>[
        _createAvatar(large: false),
        SizedBox(width: 16,),
        Expanded(child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(author.name,
                style: theme.textTheme.title,
                maxLines: _isExpanded ? 2 : 2,
                overflow: TextOverflow.fade,
              ),
              SizedBox(height: 8,),
              Text('@${author.username}',
                maxLines: _isExpanded ? 2 : 1,
                overflow: TextOverflow.fade,
                style: Theme.of(context).textTheme.caption.apply(
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),)
      ],
    );
  }

  _createAuthorDetails() {
    final theme = Theme.of(context);
    final author = widget.photo.author;
    return Column(
      children: <Widget>[
        Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            Align(
              alignment: AlignmentDirectional.center,
              child: _createAvatar(large: true),
            ),
            if (isNotEmpty(author.twitterUsername))
              Align(
                alignment: AlignmentDirectional.bottomStart,
                child: InkResponse(
                  onTap: () => launchTwitter(author.twitterUsername),
                  onLongPress: ()=> copyToClipboard(author.twitterUsername, ctx: context, toastMsg: l.twitterCopied),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: FaIcon(FontAwesomeIcons.twitter,
                      size: 32, color: Colors.blue.shade500,
                    ),
                  ),
                ),
              ),
            if (isNotEmpty(author.instagramUsername))
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: InkResponse(
                  onTap: () => launchInstagram(author.instagramUsername),
                  onLongPress: ()=> copyToClipboard(author.instagramUsername, ctx: context, toastMsg: l.instagramCopied),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: FaIcon(FontAwesomeIcons.instagram,
                      size: 32, color: Colors.blue.shade500,
                    ),
                  ),
                ),
              ),
          ],
        ),

        Padding(
          padding: EdgeInsets.only(top: 4),
          child: Text(author.name,
            textAlign: TextAlign.center,
            maxLines: _isExpanded ? 3 : 2,
            overflow: TextOverflow.fade,
            style: theme.textTheme.title,
          ),
        ),

        if (isNotEmpty(author.location))
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: RichText(
              textAlign: TextAlign.center,
              maxLines: _isExpanded ? 2 : 1,
              overflow: TextOverflow.fade,
              text: TextSpan(
                  style: Theme.of(context).textTheme.caption.apply(
                    color: Colors.grey,
                  ),
                  children: [
                    TextSpan(text: '',
                        style: theme.textTheme.overline.apply(
                          fontFamily: ui.fontMaterialIcons,
                          color: Colors.grey.shade400,
                        )
                    ),
                    TextSpan(
                      text: author.location.trim()
                    )
                  ]
              ),
            )
          ),

        if (isNotEmpty(author.portfolioUrl) || isNotEmpty(author.unsplashUrl))
          () {
            final url = isNotEmpty(author.portfolioUrl) ? author.portfolioUrl : author.unsplashUrl;
            return InkResponse(
                onTap: () => launchUrl(url),
                onLongPress: ()=> copyToClipboard(url, ctx: context, toastMsg: l.copied),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: Text(
                    url.leaveMandatoryUrl(),
                    maxLines: _isExpanded ? 2 : 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.body1.apply(
                        color: Colors.blue
                    ),
                  ),
                )
            );
          }(),

        if (isNotEmpty(author.bio))
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text(
              author.bio.trim(),
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.body1.apply(
                  color: Colors.grey.shade800
              ),
            ),
          ),
      ],
    );
  }

  _expand() {
    if (!_isExpanded )
      setState(() { _isExpanded = true; });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(3000.ms, _expand);
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: _maxWidth.toDouble()),
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16),
              child: _createPhotoInfo(),
            ),
            Divider(height: 2,),
            MaterialButton(
              onPressed: _isExpanded ? null : _expand,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: AnimatedCrossFade(
                  crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: 250.ms,
                  firstChild: _createAuthorTile(),
                  secondChild: _isExpanded ? _createAuthorDetails() : SizedBox(),
                ),
              ),
            ),
          ],
        )
      )
    );
  }

}
