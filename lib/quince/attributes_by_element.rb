# frozen_string_literal: true

require_relative "types"

module Quince
  module HtmlTagComponents
    referrer_policy = Rbs("'' | 'no-referrer' | 'no-referrer-when-downgrade' | 'origin' | 'origin-when-cross-origin' | 'same-origin' | 'strict-origin' | 'strict-origin-when-cross-origin' | 'unsafe-url' | Quince::Types::Undefined")
    form_method = Rbs(
      '"get" | "post" | "GET" | "POST" | :GET | :POST | :get | :post | Quince::Types::Undefined'
    )
    t = Quince::Types
    opt_string_sym = Rbs("#{t::OptionalString} | Symbol")
    opt_bool = t::OptionalBoolean
    opt_callback = Rbs("Quince::Callback::Interface | Quince::Types::Undefined")
    value = opt_string_sym # for now

    ATTRIBUTES_BY_ELEMENT = {
      "A" => {
        # download: t::Any,
        href: opt_string_sym,
        hreflang: opt_string_sym,
        media: opt_string_sym,
        ping: opt_string_sym,
        rel: opt_string_sym,
        target: opt_string_sym,
        type: opt_string_sym,
        referrerpolicy: referrer_policy,
      }.freeze,
      "Abbr" => {}.freeze,
      "Address" => {}.freeze,
      "Article" => {}.freeze,
      "Aside" => {}.freeze,
      "Audio" => {
        autoplay: opt_bool,
        controls: opt_bool,
        controlslist: opt_string_sym,
        crossorigin: opt_string_sym,
        loop: opt_bool,
        mediagroup: opt_string_sym,
        muted: opt_bool,
        playsinline: opt_bool,
        preload: opt_string_sym,
        src: opt_string_sym,
      }.freeze,
      "B" => {}.freeze,
      "Bdo" => {}.freeze,
      "Blockquote" => {
        cite: opt_string_sym,
      }.freeze,
      "Body" => {}.freeze,
      "Button" => {
        autofocus: opt_bool,
        disabled: opt_bool,
        form: opt_string_sym,
        formaction: opt_string_sym,
        formenctype: opt_string_sym,
        formmethod: form_method,
        formnovalidate: opt_bool,
        formtarget: opt_string_sym,
        name: opt_string_sym,
        type: Rbs("'submit' | 'reset' | 'button' | Quince::Types::Undefined"),
        value: value,
      }.freeze,
      "Canvas" => {
        height: opt_string_sym,
        width: opt_string_sym,
      }.freeze,
      "Caption" => {}.freeze,
      "Cite" => {}.freeze,
      "Code" => {}.freeze,
      "Command" => {}.freeze,
      "Colgroup" => {
        span: opt_string_sym,
      }.freeze,
      "Data" => {
        value: value,
      }.freeze,
      "Datalist" => {}.freeze,
      "Dd" => {}.freeze,
      "Del" => {
        cite: opt_string_sym,
        datetime: opt_string_sym,
      }.freeze,
      "Details" => {
        open: opt_bool,
      # ontoggle: Quince::Types::OptionalMethod;
      }.freeze,
      "Dfn" => {}.freeze,
      "Dialog" => {
        open: opt_bool,
      }.freeze,
      "Div" => {}.freeze,
      "Dl" => {}.freeze,
      "Dt" => {}.freeze,
      "Em" => {}.freeze,
      "Fieldset" => {
        disabled: opt_bool,
        form: opt_string_sym,
        name: opt_string_sym,
      }.freeze,
      "Figcaption" => {}.freeze,
      "Figure" => {}.freeze,
      "Form" => {
        "accept-charset": opt_string_sym,
        action: opt_string_sym,
        autocomplete: opt_string_sym,
        enctype: opt_string_sym,
        Method: form_method,
        name: opt_string_sym,
        novalidate: opt_bool,
        target: opt_string_sym,
      }.freeze,
      "Footer" => {}.freeze,
      "H1" => {}.freeze,
      "H2" => {}.freeze,
      "H3" => {}.freeze,
      "H4" => {}.freeze,
      "H5" => {}.freeze,
      "H6" => {}.freeze,
      "Head" => {}.freeze,
      "Header" => {}.freeze,
      "Html" => {
        manifest: opt_string_sym,
      }.freeze,
      "I" => {}.freeze,
      "Iframe" => {
        allow: opt_string_sym,
        allowfullscreen: opt_bool,
        allowtransparency: opt_bool,
        height: opt_string_sym,
        loading: Rbs('"eager" | "lazy" | Quince::Types::Undefined'),
        name: opt_string_sym,
        referrerpolicy: referrer_policy,
        sandbox: opt_string_sym,
        seamless: opt_bool,
        src: opt_string_sym,
        srcdoc: opt_string_sym,
        width: opt_string_sym,
      }.freeze,
      "Ins" => {
        cite: opt_string_sym,
        datetime: opt_string_sym,
      }.freeze,
      "Kbd" => {}.freeze,
      "Keygen" => {
        autofocus: opt_bool,
        challenge: opt_string_sym,
        disabled: opt_bool,
        form: opt_string_sym,
        keytype: opt_string_sym,
        keyparams: opt_string_sym,
        name: opt_string_sym,
      }.freeze,
      "Label" => {
        form: opt_string_sym,
        for: opt_string_sym,
      }.freeze,
      "Legend" => {}.freeze,
      "Li" => {
        value: value,
      }.freeze,
      "Main" => {},
      "Map" => {
        name: opt_string_sym,
      }.freeze,
      "Mark" => {}.freeze,
      "Menu" => {
        type: opt_string_sym,
      }.freeze,
      "Meter" => {
        form: opt_string_sym,
        high: opt_string_sym,
        low: opt_string_sym,
        Max: opt_string_sym,
        Min: opt_string_sym,
        optimum: opt_string_sym,
        value: value,
      }.freeze,
      "Nav" => {}.freeze,
      "Noscript" => {}.freeze,
      "Object" => {
        classid: opt_string_sym,
        data: opt_string_sym,
        form: opt_string_sym,
        height: opt_string_sym,
        name: opt_string_sym,
        type: opt_string_sym,
        usemap: opt_string_sym,
        width: opt_string_sym,
        wmode: opt_string_sym,
      }.freeze,
      "Ol" => {
        reversed: opt_bool,
        start: opt_string_sym,
        type: Rbs("'1' | 'a' | 'A' | 'i' | 'I' | Quince::Types::Undefined"),
      }.freeze,
      "Optgroup" => {
        disabled: opt_bool,
        label: opt_string_sym,
      }.freeze,
      "Option" => {
        disabled: opt_bool,
        label: opt_string_sym,
        selected: opt_bool,
        value: value,
      }.freeze,
      "Output" => {
        form: opt_string_sym,
        for: opt_string_sym,
        name: opt_string_sym,
      }.freeze,
      "Para" => {}, # for "p" element, in order not to clash with Ruby's common `p` method
      "Pre" => {}.freeze,
      "Progress" => {
        Max: opt_string_sym,
        value: value,
      }.freeze,
      "Q" => {}.freeze,
      "Quote" => {
        cite: opt_string_sym,
      }.freeze,
      "Rp" => {}.freeze,
      "Rt" => {}.freeze,
      "Ruby" => {}.freeze,
      "S" => {}.freeze,
      "Samp" => {}.freeze,
      "Script" => {
        async: opt_bool,
        crossorigin: opt_string_sym,
        defer: opt_bool,
        integrity: opt_string_sym,
        nomodule: opt_bool,
        nonce: opt_string_sym,
        referrerpolicy: referrer_policy,
        src: opt_string_sym,
        type: opt_string_sym,
      }.freeze,
      "Section" => {}.freeze,
      "Select" => {
        autocomplete: opt_string_sym,
        autofocus: opt_bool,
        disabled: opt_bool,
        form: opt_string_sym,
        multiple: opt_bool,
        name: opt_string_sym,
        required: opt_bool,
        Size: opt_string_sym,
        value: value,
      # onchange: Rbs::Types::OptionalMethod,
      }.freeze,
      "Small" => {}.freeze,
      "Span" => {}.freeze,
      "Strong" => {}.freeze,
      "Slot" => {
        name: opt_string_sym,
      }.freeze,
      "Style" => {
        media: opt_string_sym,
        nonce: opt_string_sym,
        scoped: opt_bool,
        type: opt_string_sym,
      }.freeze,
      "Sub" => {}.freeze,
      "Sup" => {}.freeze,
      "Table" => {
        cellpadding: opt_string_sym,
        cellspacing: opt_string_sym,
        summary: opt_string_sym,
        width: opt_string_sym,
      }.freeze,
      "Tbody" => {}.freeze,
      "Td" => {
        align: Rbs('"left" | "center" | "right" | "justify" | "char" | Quince::Types::Undefined'),
        colspan: opt_string_sym,
        headers: opt_string_sym,
        rowspan: opt_string_sym,
        scope: opt_string_sym,
        abbr: opt_string_sym,
        height: opt_string_sym,
        width: opt_string_sym,
        valign: Rbs('"top" | "middle" | "bottom" | "baseline" | Quince::Types::Undefined'),
      }.freeze,
      "Textarea" => {
        autocomplete: opt_string_sym,
        autofocus: opt_bool,
        cols: opt_string_sym,
        dirname: opt_string_sym,
        disabled: opt_bool,
        form: opt_string_sym,
        maxlength: opt_string_sym,
        minlength: opt_string_sym,
        name: opt_string_sym,
        placeholder: opt_string_sym,
        readonly: opt_bool,
        required: opt_bool,
        rows: opt_string_sym,
        value: value,
        wrap: opt_string_sym,
      # onchange: Rbs::Types::OptionalMethod,
      }.freeze,
      "Tfoot" => {}.freeze,
      "Th" => {
        align: Rbs('"left" | "center" | "right" | "justify" | "char" | Quince::Types::Undefined'),
        colspan: opt_string_sym,
        headers: opt_string_sym,
        rowspan: opt_string_sym,
        scope: opt_string_sym,
        abbr: opt_string_sym,
      }.freeze,
      "Thead" => {}.freeze,
      "Title" => {}.freeze,
      "Time" => {
        datetime: opt_string_sym,
      }.freeze,
      "Tr" => {}.freeze,
      "U" => {}.freeze,
      "Ul" => {}.freeze,
      "Var" => {}.freeze,
      "Video" => {
        autoplay: opt_bool,
        controls: opt_bool,
        controlslist: opt_string_sym,
        crossorigin: opt_string_sym,
        height: opt_string_sym,
        loop: opt_bool,
        mediagroup: opt_string_sym,
        muted: opt_bool,
        playsinline: opt_bool,
        poster: opt_string_sym,
        preload: opt_string_sym,
        src: opt_string_sym,
        width: opt_string_sym,
      }.freeze,
    }.freeze

    SELF_CLOSING_TAGS = {
      "Area" => {
        alt: opt_string_sym,
        coords: opt_string_sym,
        # download: t::Any,
        href: opt_string_sym,
        hreflang: opt_string_sym,
        media: opt_string_sym,
        referrerpolicy: referrer_policy,
        rel: opt_string_sym,
        shape: opt_string_sym,
        target: opt_string_sym,
      }.freeze,
      "Base" => {
        href: opt_string_sym,
        target: opt_string_sym,
      }.freeze,
      "Br" => {}.freeze,
      "Col" => {
        span: opt_string_sym,
        width: opt_string_sym,
      }.freeze,
      "Embed" => {
        height: opt_string_sym,
        src: opt_string_sym,
        type: opt_string_sym,
        width: opt_string_sym,
      }.freeze,
      "Hr" => {}.freeze,
      "Img" => {
        alt: opt_string_sym,
        crossorigin: Rbs('"anonymous" | "use-credentials" | "" | Quince::Types::Undefined'),
        decoding: Rbs('"async" | "auto" | "sync" | Quince::Types::Undefined'),
        height: Rbs("#{opt_string_sym} | Integer"),
        loading: Rbs('"eager" | "lazy" | Quince::Types::Undefined'),
        referrerpolicy: referrer_policy,
        sizes: opt_string_sym,
        src: opt_string_sym,
        srcSet: opt_string_sym,
        useMap: opt_string_sym,
        width: Rbs("#{opt_string_sym} | Integer"),
      }.freeze,
      "Input" => {
        accept: opt_string_sym,
        alt: opt_string_sym,
        autocomplete: opt_string_sym,
        autofocus: opt_bool,
        capture: Rbs("String | #{opt_bool}"),
        checked: opt_bool,
        crossorigin: opt_string_sym,
        disabled: opt_bool,
        form: opt_string_sym,
        formaction: opt_string_sym,
        formenctype: opt_string_sym,
        formmethod: form_method,
        formnovalidate: opt_bool,
        formtarget: opt_string_sym,
        height: opt_string_sym,
        list: opt_string_sym,
        Max: opt_string_sym,
        maxlength: opt_string_sym,
        Min: opt_string_sym,
        minlength: opt_string_sym,
        multiple: opt_bool,
        name: opt_string_sym,
        pattern: opt_string_sym,
        placeholder: opt_string_sym,
        readonly: opt_bool,
        required: opt_bool,
        Size: opt_string_sym,
        src: opt_string_sym,
        step: opt_string_sym,
        type: opt_string_sym,
        value: value,
        width: opt_string_sym,
      # onchange: Rbs::Types::OptionalMethod,
      }.freeze,
      "Link" => {
        as: opt_string_sym,
        crossorigin: opt_string_sym,
        href: opt_string_sym,
        hreflang: opt_string_sym,
        integrity: opt_string_sym,
        media: opt_string_sym,
        referrerpolicy: referrer_policy,
        rel: opt_string_sym,
        sizes: opt_string_sym,
        type: opt_string_sym,
        charset: opt_string_sym,
      }.freeze,
      "Meta" => {
        charSet: opt_string_sym,
        content: opt_string_sym,
        "http-equiv": opt_string_sym,
        name: opt_string_sym,
      }.freeze,
      "Param" => {
        name: opt_string_sym,
        value: value,
      }.freeze,
      "Source" => {
        media: opt_string_sym,
        sizes: opt_string_sym,
        src: opt_string_sym,
        srcset: opt_string_sym,
        type: opt_string_sym,
      }.freeze,
      "Track" => {
        default: opt_bool,
        kind: opt_string_sym,
        label: opt_string_sym,
        src: opt_string_sym,
        srclang: opt_string_sym,
      }.freeze,
      "Wbr" => {}.freeze,
    }.freeze

    GLOBAL_HTML_ATTRS = {
      accesskey: opt_string_sym,
      Class: opt_string_sym,
      contenteditable: opt_string_sym,
      # data-*: opt_string_sym,
      dir: opt_string_sym,
      draggable: opt_string_sym,
      hidden: opt_string_sym,
      id: opt_string_sym,
      lang: opt_string_sym,
      spellcheck: opt_string_sym,
      style: opt_string_sym,
      tabindex: opt_string_sym,
      title: opt_string_sym,
      translate: opt_string_sym,
    }.freeze

    DOM_EVENTS = {
      onclick: opt_callback,
      onsubmit: opt_callback,
      onblur: opt_callback,
      onchange: opt_callback,
      onsearch: opt_callback,
      onkeyup: opt_callback,
      onselect: opt_callback,
    }.freeze
  end
end

Undefined = Quince::Types::Undefined
