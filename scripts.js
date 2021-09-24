const Q = {
  c: (endpoint, payload, selector, mode, handleErrors) => {
    return fetch(
      endpoint,
      {
        method: `POST`,
        headers: {
          "Content-Type": `application/json;charset=utf-8`
        },
        body: payload,
      }
    ).then(resp => {
      if (resp.status <= 299) {
        return resp.text()
      } else if (resp.status >= 500) {
        throw Q.em["500"];
      } else {
        let msg = Q.em[`${resp.code}`];
        
        if (!msg && resp.code >= 400) msg = Q.em.generic;
        
        throw msg;
      }
    }).then(html => {
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
    }).catch(err => {
      if (!handleErrors) throw err;

      let msg;
      if (typeof err === "string") {
        msg = err;
      } else if (err.message) {
        if (err.message.startsWith("NetworkError")) {
          msg = Q.em.network;
        } else {
          msg = err.message;
        }
      } else msg = Q.em.generic;
      Q.e(msg, 2500);
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
  },
  e: (msg, durationMs) => {
    const containerClassName = "quince-err-container";
    document.querySelectorAll(`.${containerClassName}`).forEach(e => e.remove());
    const container = document.createElement("div");
    const strong = document.createElement("strong");
    strong.innerText = msg;
    container.className = containerClassName;
    strong.className = "quince-err-msg";
    container.appendChild(strong);
    document.body.insertAdjacentElement("afterbegin", container);
    setTimeout(() => container.remove(), durationMs);
  },
  em: {
    400: "Bad request",
    401: "Unauthorised",
    402: "Payment required",
    403: "Forbidden",
    404: "Not found",
    422: "Unprocessable entity",
    429: "Too many requests",
    500: "Internal server error",
    generic: "An error occurred",
    network: "Network error", 
  }
};
