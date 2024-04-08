let buttonParams = [];
let selectedButtonIndex = 0;

var s_swipe = new Audio('assets/sonido/transition.ogg');
var s_over = new Audio('assets/sonido/over.wav');
var s_click = new Audio('assets/sonido/click.mp3');

s_swipe.volume = 0.2;
s_over.volume = 0.1;
s_click.volume = 0.1;

const openMenu = (data = null) => {
	$('#buttons').html("<div class='buttons-list'></div>");

	let html = '';
	data.forEach((item, index) => {
		if (!item.hidden) {
			let header = item.header;
			let message = item.txt || item.text;
			let isMenuHeader = item.isMenuHeader;
			let isDisabled = item.disabled;
			let icon = item.icon;
			if (!isMenuHeader) {
				html += getButtonRender(
					header,
					message,
					index,
					isMenuHeader,
					isDisabled,
					icon
				);
			} else {
				$('#buttons').prepend(
					getButtonRender(
						header,
						message,
						index,
						isMenuHeader,
						isDisabled,
						icon
					)
				);
			}
			if (item.params) buttonParams[index] = item.params;
		}
	});

	$('#buttons .buttons-list').html(html);
	$('#container').addClass('show');
	s_swipe.currentTime = '0';
	s_swipe.play();

	$('.button.active').eq(selectedButtonIndex).addClass('selected');
};

const getButtonRender = (header, message = null, id, isMenuHeader, isDisabled, icon) => {
	return `
        <div class="${isMenuHeader ? 'title' : 'button'} ${
		isDisabled ? 'disabled' : 'active'
	}" id="${id}">
            <div class="icon"> <i class="${icon}" onerror="this.onerror=null; this.remove();"></i> </div>
            <div class="column">
            <div class="header"> ${header}</div>
            ${message ? `<div class="text">${message}</div>` : ''}
            </div>
        </div>
    `;
};

const closeMenu = () => {
	$('#container').removeClass('show');
	s_swipe.currentTime = '0';
	s_swipe.play();
	setTimeout(() => {
		$('#buttons').html("<div class='buttons-list'></div>");
		buttonParams = [];
		selectedButtonIndex = 0;
	}, 250);
};

const postData = (id) => {
	$.post(
		`https://${GetParentResourceName()}/clickedButton`,
		JSON.stringify(parseInt(id) + 1)
	);
	return true;
};

const cancelMenu = () => {
	$.post(`https://${GetParentResourceName()}/closeMenu`);
	selectedButtonIndex = 0;
	return closeMenu();
};

const updateMenu = (option, key, value) => {
	const $opt = $(`#${option - 1}`);

	switch (key) {
		case 'header':
			$opt.find('.header').html(value);
			break;
		case 'txt':
			$opt.find('.text').html(value);
			break;
		case 'icon':
			$opt.find('.icon').html(
				`<i class="${value}" onerror="this.onerror=null; this.remove();"></i>`
			);
			break;
		case 'disabled':
			if (value) {
				$opt.addClass('disabled');
			} else {
				$opt.removeClass('disabled');
			}
			break;
		case 'hidden':
			if (value) {
				$opt.removeClass('active');
			} else {
				$opt.addClass('active');
			}
			break;
		default:
			break;
	}
};

window.addEventListener('message', (event) => {
	const data = event.data;
	const buttons = data.data;
	const action = data.action;
	switch (action) {
		case 'OPEN_MENU':
		case 'SHOW_HEADER':
			return openMenu(buttons);
		case 'CLOSE_MENU':
			return closeMenu();
		case 'UPDATE_OPTION':
			return updateMenu(data.option, data.key, data.value);
		case 'HIDE_MENU':
			$('#container').removeClass('show');
			return;
		case 'SHOW_MENU':
			$('#container').addClass('show');
			return;
		default:
			return;
	}
});

document.onkeyup = function (event) {
	const charCode = event.key;
	if (charCode == 'Escape') {
		cancelMenu();
	}
};

$(document).on('wheel', function (e) {
	if (e.originalEvent.deltaY < 100) {
		// Increased threshold for sensitivity
		if (selectedButtonIndex > 0) {
			$('.button.active').eq(selectedButtonIndex).removeClass('selected');
			selectedButtonIndex--;
			$('.button.active').eq(selectedButtonIndex).addClass('selected');

			$('.button.selected')[0].scrollIntoView(false);

			s_over.currentTime = '0';
			s_over.play();
		}
	} else {
		if (selectedButtonIndex < $('.button.active').length - 1) {
			if (selectedButtonIndex >= 0) {
				$('.button.active').eq(selectedButtonIndex).removeClass('selected');
			}
			selectedButtonIndex++;
			$('.button.active').eq(selectedButtonIndex).addClass('selected');
			$('.button.active').eq(selectedButtonIndex).addClass('selected');

			$('.button.selected')[0].scrollIntoView(false);

			s_over.currentTime = '0';
			s_over.play();
		}
	}
});

$(document).on('click', function (e) {
	const target = $('.button.selected');
	if (target.length != 0 && !target.hasClass('title') && !target.hasClass('disabled')) {
		s_click.currentTime = '0';
		s_click.play();
		postData(target.attr('id'));
	}
});

document.addEventListener('mousedown', function (event) {
	if (event.button === 2) {
		cancelMenu();
	}
});
