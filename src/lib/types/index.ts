export type LabelMessage = {
	label: string;
	message: string;
}

export type ErrorData = {
	code: number;
	message: string;
	status: boolean;
	invalidList?: LabelMessage[]
}