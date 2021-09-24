const Q = {
  c: (endpoint, payload, selector, mode = "replace") => {
    return fetch(
      endpoint,
      {
        method: `POST`,
        headers: {
          "Content-Type": `application/json;charset=utf-8`
        },
        body: payload,
      }
    ).then(resp => resp.text()).then(html => {
      const element = document.querySelector(selector);
      if (!element) {
        throw `element not found for ${selector}`;
      }

      switch (mode) {
        case "append_diff":
          const tmpElem = document.createElement(element.nodeName);
          tmpElem.innerHTML = html;
          const newNodes = Array.from(tmpElem.childNodes);
          const script = newNodes.pop();
          const existingChildren = element.childNodes;
          // This comparison doesn't currently work because of each node's unique id (data-quid).
          // maybe it would be possible to use regex replace to on the raw html, but it could also
          // be overkill
          // let c = 0;
          // for (; c < existingChildren.length; c++) {
          //   if (existingChildren[c].isEqualNode(newNodes[c]))
          //     continue;
          //   else
          //     break;
          // }
          // for the time being, we can just assume that we can just take the extra items
          let c = existingChildren.length;
          for (const node of newNodes.slice(c)) {
            element.appendChild(node);
          }

          const newScript = document.createElement("script");
          newScript.dataset.quid = script.dataset.quid;
          newScript.innerHTML = script.innerHTML;
          document.head.appendChild(newScript);
          break;
        case "replace": 
          element.outerHTML = html;
          break;
        default:
          throw `mode ${mode} is not valid`;
      }
    })
  },
  f: (elem) => {
    let form = elem.localName === "form" ? elem : elem.form;
    if (!form) {
      throw `element ${elem} should belong to a form`;
    }
    const fd = new FormData(form);
    return Object.fromEntries(fd.entries());
  },
  d: (func, wait_ms) => {
    let timer = null;

    return (...args) => {
      clearTimeout(timer);
      return new Promise((resolve) => {
        timer = setTimeout(
          () => resolve(func(...args)),
          wait_ms,
        );
      });
    };
  },
  ps: (stateObj) => {
    const base = location.origin + location.pathname;
    const url = new URL(base);
    for (const p in stateObj) {
      url.searchParams.append(p, stateObj[p]);
    };
    window.history.pushState({}, document.title, url);
  }
};
