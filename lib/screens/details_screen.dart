import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share/share.dart';
import 'package:unsplash_gallery/data.dart';
import 'package:unsplash_gallery/localization.dart';
import 'package:unsplash_gallery/ui.dart';
import 'package:unsplash_gallery/util.dart';

const _avatarSize = 128;
const _maxWidth = 300;

class DetailsScreen extends StatefulWidget {

  final Foto foto;

  const DetailsScreen(this.foto);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();

}

class _DetailsScreenState extends State<DetailsScreen> {

  Foto get foto => widget.foto;

  var _isExpanded = false;

  _createFotoInfo() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: InkResponse(
                onTap: () => launchUrl(foto.htmlUrl),
                onLongPress: ()=> copyToClipboard(foto.htmlUrl, ctx: context, toastMsg: 'Copied!'),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    beautifyUrl(foto.htmlUrl),
                    style: theme.textTheme.body1.apply(
                        color: Colors.blue
                    ),
                  )
                )
              )
            ),
            InkResponse(
              onTap: () => Share.share(foto.htmlUrl),
              child: Tooltip(
                message: AppLocalizations.of(context).share,
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

        if (isNotEmpty(foto.description))
          Text(
            foto.description.trim(),
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
    final author = widget.foto.author;
    final avatarUrl = author.prepareAvatarUrl(_avatarSize, window);
    print(avatarUrl);
    return InkResponse(
      onTap:       isNotEmpty(author.unsplashUrl) ? () => launchUrl(author.unsplashUrl) : null,
      onLongPress: isNotEmpty(author.unsplashUrl) ? () =>
          copyToClipboard(author.unsplashUrl, ctx: context, toastMsg: 'Author page url copied!') : null,
      child: CircleAvatar(
        maxRadius: _avatarSize / (large ? 2 : 4),
        backgroundImage: NetworkImage(avatarUrl),
      ),
    );
  }

  _createAuthorTile() {
    final theme = Theme.of(context);
    final author = widget.foto.author;
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
    final author = widget.foto.author;
    final avatarUrl = author.prepareAvatarUrl(_avatarSize, window);
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
                  onLongPress: ()=> copyToClipboard(author.twitterUsername, ctx: context, toastMsg: 'Author Twitter name copied!'),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: SvgPicture.asset(
                      assetsSvgIcon('twitter'),
                      width: 32, color: Colors.blue.shade500,
                    ),
                  ),
                ),
              ),
            if (isNotEmpty(author.instagramUsername))
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: InkResponse(
                  onTap: () => launchInstagram(author.instagramUsername),
                  onLongPress: ()=> copyToClipboard(author.instagramUsername, ctx: context, toastMsg: 'Author Instagram name copied!'),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: SvgPicture.asset(
                      assetsSvgIcon('instagram'),
                      width: 32, color: Colors.blue.shade500,
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
                          fontFamily: fontMaterialIcons,
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
                onLongPress: ()=> copyToClipboard(url, ctx: context, toastMsg: 'Copied!'),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: Text(
                    beautifyUrl(url),
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
//    Future.delayed(Duration(milliseconds: 300), _expandAuthor);
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: _maxWidth.toDouble()),
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16),
              child: _createFotoInfo(),
            ),
            Divider(height: 2,),
            MaterialButton(
              onPressed: _isExpanded ? null : _expand,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: AnimatedCrossFade(
                  crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: Duration(milliseconds: 250),
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
