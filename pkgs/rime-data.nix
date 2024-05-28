{
  stdenvNoCC,
  fetchzip,
  fetchurl,
}:
let
  dicts = {
    project_trans = fetchurl {
      url = "https://github.com/project-trans/rime-dict/releases/download/unstable-20231115/project_trans.dict.yaml";
      hash = "sha256-YG3xB/Ip3ZQ+Y6sqb4yD/rQDsRqQUWdiA8bH6FmC84E=";
    };

    project_trans_pinyin = fetchurl {
      url = "https://github.com/project-trans/rime-dict/releases/download/unstable-20231115/project_trans_pinyin.dict.yaml";
      hash = "sha256-YTSM+wXDrHiJfwh3eLeUmHvTotIJzEmk7uPHUqYIMlE=";
    };

    zhwiki = fetchurl {
      url = "https://github.com/felixonmars/fcitx5-pinyin-zhwiki/releases/download/0.2.5/zhwiki-20240509.dict.yaml";
      hash = "sha256-lihR5q+brhaweHD1ggtAzvFMqQ2Rt+REeOH4K8V20gI=";
    };
  };
in
stdenvNoCC.mkDerivation {
  pname = "rime-data";
  version = "0";

  src = fetchzip {
    url = "https://github.com/iDvel/rime-ice/releases/download/2024.05.21/full.zip";
    hash = "sha256-Vnbp3OMQSDbrsLcwSixZa+QBcxZo0yZkR93Ne2KDMUA=";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out/share/
    cp -r . $out/share/rime-data/
    chmod +r $out/share/rime-data/cn_dicts/
    install -T ${dicts.project_trans} $out/share/rime-data/cn_dicts/project_trans.dict.yaml
    install -T ${dicts.project_trans_pinyin} $out/share/rime-data/cn_dicts/project_trans_pinyin.dict.yaml
    install -T ${dicts.zhwiki} $out/share/rime-data/cn_dicts/zhwiki.dict.yaml
  '';

  postFixup = ''
    sed -i \
      -e "16a\  - cn_dicts/zhwiki" \
      -e "16a\  - cn_dicts/project_trans_pinyin" \
      -e "16a\  - cn_dicts/project_trans" \
      $out/share/rime-data/rime_ice.dict.yaml
  '';
}
